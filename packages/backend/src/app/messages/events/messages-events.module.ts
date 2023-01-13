import { Module } from '@nestjs/common';
import { AuthModule } from '../../auth/auth.module';
import { MessagesModule } from '../messages.module';
import { MessagesEventsGateway } from './messages-events.gateway';

@Module({
  imports: [AuthModule, MessagesModule],
  providers: [MessagesEventsGateway],
})
export class MessagesEventsModule {}
