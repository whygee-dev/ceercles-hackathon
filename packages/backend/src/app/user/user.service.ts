import { Injectable } from '@nestjs/common';
import { Prisma, Role, User, UserProfile } from '@prisma/client';
import { PrismaService } from 'nestjs-prisma';
import * as bcrypt from 'bcrypt';
import { ForbiddenError } from 'apollo-server-express';
import { EmailsService } from '../emails/emails.service';
import { differenceInHours } from 'date-fns';
import { SPEAKER_ROLES } from '../constants';

@Injectable()
export class UserService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly emailService: EmailsService
  ) {}

  async user(
    userWhereUniqueInput: Prisma.UserWhereUniqueInput,
    include: Prisma.UserInclude = { profile: false }
  ): Promise<
    | (User & { profile?: UserProfile } & {
        contacts?: User[];
      })
    | null
  > {
    return this.prisma.user.findUnique({
      where: userWhereUniqueInput,
      include,
    });
  }

  async users(
    take = 30,
    skip = 0,
    emailSearch = null,
    fullnameSearch = null,
    adminId: string
  ): Promise<{ users: User[]; count: number }> {
    const params: Prisma.UserFindManyArgs = {
      take,
      skip,
      where: { deleted: false, id: { not: adminId } },
      include: { profile: true },
    };

    if (emailSearch) {
      params.where.email = { contains: emailSearch, mode: 'insensitive' };
    }

    if (fullnameSearch) {
      params.where.fullname = { contains: fullnameSearch, mode: 'insensitive' };
    }

    const [users, count] = await Promise.all([
      this.prisma.user.findMany(params),
      this.prisma.user.count({ where: params.where }),
    ]);

    return { users, count };
  }

  async createUser(data: Prisma.UserCreateInput): Promise<User> {
    const user = data;
    const admin = await this.prisma.user.findFirst({
      where: { roles: { hasSome: SPEAKER_ROLES } },
    });

    user.password = await bcrypt.hash(data.password, 11);
    user.roles = [Role.USER];

    // user.receivedMessages = {
    //   create: {
    //     text: "Bienvenue à Ceercles! Si vous avez une question quelconque, n'hésitez pas à m'envoyer un message.",
    //     sender: { connect: { id: admin.id } },
    //   },
    // };

    try {
      const result = await this.prisma.user.create({
        data: user,
      });

      // await this.prisma.user.update({
      //   where: { id: admin.id },
      //   data: { contacts: { connect: { id: result.id } } },
      // });

      await this.sendEmailConfirmation(result.id);

      return result;
    } catch (e) {
      if (e instanceof Prisma.PrismaClientKnownRequestError) {
        if (e.code === 'P2002') {
          throw new Error('Un compte avec cette adresse email existe déjà.');
        } else {
          throw new Error('Une erreur inattendu est survenue :/');
        }
      }
    }
  }

  async sendEmailConfirmation(userId: string) {
    const user = await this.user({ id: userId });

    try {
      await this.emailService.sendEmail({
        to: user,
        subject: 'Ceercles - Confirmation de votre adresse email',
        variables: {
          link: `${process.env.URL}/redirects/deep-link/verify-email?token=${user.verificationToken}`,
          fullname: user.fullname,
        },
        template: 'EmailConfirmation.html',
      });

      return true;
    } catch (error) {
      return false;
    }
  }

  async verifyEmail(userId: string, token: string) {
    const user = await this.user({ id: userId });

    if (user.verificationToken === token) {
      await this.prisma.user.update({
        where: { id: userId },
        data: { emailVerified: true },
      });

      return true;
    }

    return false;
  }

  async updateUser(params: {
    where: Prisma.UserWhereUniqueInput;
    data: Prisma.UserUpdateInput;
  }): Promise<User> {
    const { where, data } = params;
    const user = data;

    if (user.password) {
      user.password = await bcrypt.hash(data.password as string, 11);
    }

    try {
      const result = await this.prisma.user.update({
        data: user,
        where,
      });

      return result;
    } catch (e) {
      if (e instanceof Prisma.PrismaClientKnownRequestError) {
        if (e.code === 'P2002') {
          throw new Error('An account with this email already exists.');
        } else {
          throw new Error('An unexpected error occured');
        }
      }
    }
  }

  async deleteUser(where: Prisma.UserWhereUniqueInput): Promise<User> {
    const deletedUser = await this.prisma.user.findFirst({
      where: { roles: { has: Role.DELETED_USER } },
    });

    await this.prisma.message.updateMany({
      where: { sender: where },
      data: { text: deletedUser.fullname },
    });

    const update = await this.prisma.user.update({
      where,
      data: {
        deleted: true,
        fullname: deletedUser.fullname,
        banned: true,
      },
      include: { profile: true },
    });

    if (update.profile) {
      await this.prisma.userProfile.delete({ where: { id: where.id } });
    }

    return update;
  }

  async generatePasswordReset(email: string) {
    const user = await this.user({ email });

    if (!user) {
      return true;
    }

    try {
      try {
        await this.prisma.passwordReset.delete({ where: { id: user.id } });
      } catch (error) {
        // Do nothing
      }

      const reset = await this.prisma.passwordReset.create({
        data: { user: { connect: { id: user.id } } },
      });

      await this.emailService.sendEmail({
        to: user,
        subject: 'Ceercles - Réinitialiser votre mot de passe',
        variables: {
          link: `${process.env.URL}/redirects/deep-link/password-reset?token=${reset.id}`,
          fullname: user.fullname,
        },
        template: 'PasswordReset.html',
      });

      return true;
    } catch (error) {
      console.log(error);
      return false;
    }
  }

  async resetPassword(newPassword: string, token: string) {
    const reset = await this.prisma.passwordReset.findUnique({
      where: { id: token },
    });

    if (
      !reset ||
      reset.used ||
      differenceInHours(reset.createdAt, new Date()) >= 1
    ) {
      throw new ForbiddenError('Réinitialisation invalide');
    }

    const newPasswordHash = await bcrypt.hash(newPassword, 11);

    try {
      await this.prisma.$transaction([
        this.prisma.user.update({
          where: { id: reset.userId },
          data: { password: newPasswordHash },
        }),
        this.prisma.passwordReset.update({
          where: { id: reset.id },
          data: { used: true },
        }),
      ]);

      return true;
    } catch (error) {
      return false;
    }
  }
}
