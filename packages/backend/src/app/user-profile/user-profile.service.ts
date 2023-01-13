import { Injectable, InternalServerErrorException } from '@nestjs/common';
import { ForbiddenError } from 'apollo-server-express';
import { PrismaService } from 'nestjs-prisma';
import { UserService } from '../user/user.service';
import { CreateUserProfileInput } from './dto/create-user-profile.input';
import { UpdateUserProfileInput } from './dto/update-user-profile.input';

@Injectable()
export class UserProfileService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly userService: UserService
  ) {}

  async create(data: CreateUserProfileInput) {
    const { userId, ...rest } = data;

    const user = await this.userService.user({ id: userId }, { profile: true });

    if (user && user.profile) {
      throw new ForbiddenError('User already has a profile');
    }

    const profil = await this.prisma.userProfile.create({
      data: {
        ...rest,
        user: { connect: { id: userId } },
      },
    });

    if (!profil) {
      throw new InternalServerErrorException('Profile creation failed');
    }

    return { ...profil, userId };
  }

  update(data: UpdateUserProfileInput) {
    const { userId: id, ...rest } = data;

    const clean = Object.fromEntries(
      Object.entries(rest).filter(([_, v]) => v != null)
    );

    if (Object.keys(clean).length !== 0) {
      return this.prisma.userProfile.update({
        data: clean,
        where: {
          id,
        },
      });
    }

    return { id };
  }

  findOne(id: string) {
    return this.prisma.userProfile.findUnique({
      where: { id },
    });
  }

  updateAvatar(id: string, avatar: string) {
    return this.prisma.userProfile.update({
      where: { id },
      data: { avatar },
    });
  }

  async findAvatar(userId: string) {
    const res = await this.prisma.userProfile.findUnique({
      where: { id: userId },
      select: { avatar: true },
    });

    if (!res || !res.avatar) {
      throw new ForbiddenError('User not found or user has no avatar');
    }

    return this.prisma.userProfile.findUnique({
      where: { id: userId },
      select: { avatar: true },
    });
  }
}
