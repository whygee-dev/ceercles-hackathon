import {
  UseFilters,
  UseGuards,
  UsePipes,
  ValidationPipe,
} from '@nestjs/common';
import {
  ConnectedSocket,
  MessageBody,
  SubscribeMessage,
  WebSocketGateway,
  WebSocketServer,
} from '@nestjs/websockets';
import { Message } from '@prisma/client';
import { Server, Socket } from 'socket.io';
import { AuthService } from '../../auth/auth.service';
import { WsAuthGuard } from '../../auth/guards/ws-auth.guard';
import { WsExceptionFilter } from '../../exception-filters/ws-exception.filter';
import { CreateMessageDto } from '../dto/create-message.dto';
import { MessagesService } from '../messages.service';

interface IConnectedUsers {
  [keys: string]: string;
}

@UseFilters(WsExceptionFilter)
@WebSocketGateway(Number.parseInt(process.env.PORT || '3333') + 1, {
  cors: {
    origin: '*',
  },
})
export class MessagesEventsGateway {
  constructor(
    private readonly authService: AuthService,
    private readonly messagesService: MessagesService
  ) {}

  @WebSocketServer()
  server: Server;

  @UsePipes(new ValidationPipe())
  @SubscribeMessage('MESSAGE')
  @UseGuards(WsAuthGuard)
  async sendMessage(
    @ConnectedSocket() client: Socket,
    @MessageBody() data: CreateMessageDto
  ): Promise<Message> {
    const senderId = this.socketToUser[client.id];

    if (!senderId) return null;

    const create = await this.messagesService.create(senderId, data);
    const message = await create.create;

    if (create.allowed) {
      this.server
        .to(this.userToSocket[data.receiverId])
        .emit('MESSAGE', message);

      this.server.to(client.id).emit('MESSAGE', message);
    }

    if (create.shouldAdminSyncContacts) {
      this.server
        .to(this.userToSocket[data.receiverId])
        .emit('ADD_CONTACT', { senderId });
    }

    return message;
  }

  private socketToUser: IConnectedUsers = {};
  private userToSocket: IConnectedUsers = {};

  async handleConnection(client: Socket) {
    const user = await this.authService.verify(
      client.handshake.headers.authorization?.split(' ')[1]
    );

    if (user) {
      this.userToSocket[user.sub] = client.id;
      this.socketToUser[client.id] = user.sub;
    } else {
      client.disconnect();
    }
  }
}
