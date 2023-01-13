import { Injectable } from '@nestjs/common';
import { Message, Role, User } from '@prisma/client';
import { ForbiddenError } from 'apollo-server-express';
import { PrismaService } from 'nestjs-prisma';
import { ADMIN_ROLES } from '../auth/decorators/roles.decorator';
import { SPEAKER_ROLES } from '../constants';
import { UserService } from '../user/user.service';
import { CreateMessageDto } from './dto/create-message.dto';
import { GetAllContactsInput } from './dto/get-all-contacts.dto';
import { GetMessageInput } from './dto/get-messages.input';

@Injectable()
export class MessagesService {
  constructor(
    private readonly userService: UserService,
    private readonly prisma: PrismaService
  ) {}

  canExchangeMessage(
    sender: User & { contacts?: User[]; contactsRelation?: User[] },
    receiver: User & { contacts?: User[]; contactsRelation?: User[] }
  ) {
    const hasReceiverInContacts =
      sender.contacts.find((c) => c.id === receiver.id) ||
      sender.contactsRelation.find((c) => c.id === receiver.id);

    const hasSenderInContacts =
      receiver.contacts.find((c) => c.id === sender.id) ||
      receiver.contactsRelation.find((c) => c.id === sender.id);

    const shouldAdminSyncContacts =
      !hasSenderInContacts && receiver.roles.includes(Role.ADMIN);

    return {
      allowed: hasReceiverInContacts,
      shouldAdminSyncContacts,
    };
  }

  async create(senderId, data: CreateMessageDto) {
    const sender = await this.userService.user(
      { id: senderId },
      { contacts: true, contactsRelation: true }
    );
    const receiver = await this.userService.user(
      { id: data.receiverId },
      { contacts: true, contactsRelation: true }
    );

    if (!sender || !receiver) {
      throw new ForbiddenError('Sender or receiver not found');
    }

    const canExchange = this.canExchangeMessage(sender, receiver);

    if (!canExchange.allowed) {
      throw new ForbiddenError(
        'Messages can only be between an user and an admin that include each other in their contacts'
      );
    }

    if (canExchange.shouldAdminSyncContacts) {
      await this.prisma.user.update({
        where: { id: receiver.id },
        data: { contacts: { connect: { id: sender.id } } },
      });
    }

    return {
      ...canExchange,
      create: this.prisma.message.create({
        data: {
          text: data.text,
          sender: { connect: { id: senderId } },
          receiver: { connect: { id: data.receiverId } },
        },
        include: {
          sender: { select: { id: true, fullname: true } },
          receiver: { select: { id: true, fullname: true } },
        },
      }),
    };
  }

  async getAllContacts(userId: string, options: GetAllContactsInput) {
    const user = await this.prisma.user.findUnique({
      where: { id: userId },
    });

    if (user.roles.some((r) => SPEAKER_ROLES.includes(r))) {
      const userPopulated = await this.prisma.user.findUnique({
        where: { id: userId },
        include: {
          contacts: {
            take: options.take,
            skip: options.skip,
            where: {
              fullname: { contains: options.search, mode: 'insensitive' },
              deleted: false,
            },
            select: {
              id: true,
              fullname: true,
              receivedMessages: {
                where: { senderId: userId },
                take: 1,
                orderBy: { createdAt: 'desc' },
                include: {
                  sender: { select: { fullname: true, id: true } },
                  receiver: { select: { fullname: true, id: true } },
                },
              },
              sentMessages: {
                where: { receiverId: userId },
                take: 1,
                orderBy: { createdAt: 'desc' },
                include: {
                  sender: { select: { fullname: true, id: true } },
                  receiver: { select: { fullname: true, id: true } },
                },
              },
            },
          },
        },
      });

      const transformedContacts: {
        id: string;
        fullname: string;
        lastMessage: Message;
      }[] = userPopulated.contacts.map((c) => ({
        id: c.id,
        fullname: c.fullname,
        lastMessage:
          (c.receivedMessages[0]?.createdAt.getTime() || -1) >
          (c.sentMessages[0]?.createdAt.getTime() || -1)
            ? c.receivedMessages[0]
            : c.sentMessages[0],
      }));

      return transformedContacts;
    } else {
      const userPopulated = await this.prisma.user.findUnique({
        where: { id: userId },
        include: {
          contactsRelation: {
            take: options.take,
            skip: options.skip,
            where: {
              fullname: {
                contains: options.search,
                mode: 'insensitive',
              },
              deleted: false,
            },
            select: {
              id: true,
              fullname: true,
              receivedMessages: {
                where: { senderId: userId },
                take: 1,
                orderBy: { createdAt: 'desc' },
                include: {
                  sender: { select: { fullname: true, id: true } },
                  receiver: { select: { fullname: true, id: true } },
                },
              },
              sentMessages: {
                where: { receiverId: userId },
                take: 1,
                orderBy: { createdAt: 'desc' },
                include: {
                  sender: { select: { fullname: true, id: true } },
                  receiver: { select: { fullname: true, id: true } },
                },
              },
            },
          },
        },
      });

      const transformedContacts: {
        id: string;
        fullname: string;
        lastMessage: Message;
      }[] = userPopulated.contactsRelation.map((c) => ({
        id: c.id,
        fullname: c.fullname,
        lastMessage:
          (c.receivedMessages[0]?.createdAt.getTime() || -1) >
          (c.sentMessages[0]?.createdAt.getTime() || -1)
            ? c.receivedMessages[0]
            : c.sentMessages[0],
      }));

      return transformedContacts;
    }
  }

  getContactMessages(data: GetMessageInput) {
    return this.prisma.message.findMany({
      where: {
        OR: [
          {
            senderId: data.userId,
            receiverId: data.contactId,
          },
          {
            senderId: data.contactId,
            receiverId: data.userId,
          },
        ],
      },
      include: {
        sender: { select: { id: true, fullname: true } },
        receiver: { select: { id: true, fullname: true } },
      },
      orderBy: { createdAt: 'desc' },
      take: data.take,
      skip: data.skip,
    });
  }

  remove(id: number) {
    return `This action removes a #${id} message`;
  }
}
