import { Resolver, Query, Args } from '@nestjs/graphql';
import { MessagesService } from './messages.service';
import { Message } from './model/message.model';
import { CurrentUser } from '../graphql/current-user.decorator';
import { UseGuards } from '@nestjs/common';
import { GqlAuthGuard } from '../auth/guards/jwt-gql-auth.guard';
import { User } from '../user/models/user.model';
import { GetMessageInput } from './dto/get-messages.input';
import { UserMin } from '../user/models/user-min.model';
import { GetAllContactsInput } from './dto/get-all-contacts.dto';
import { SkipThrottle } from '@nestjs/throttler';

@Resolver(() => Message)
export class MessagesResolver {
  constructor(private readonly messagesService: MessagesService) {}

  @Query(() => [UserMin])
  @UseGuards(GqlAuthGuard)
  getAllContacts(
    @CurrentUser() user: User,
    @Args('data', { nullable: true }) data: GetAllContactsInput
  ) {
    return this.messagesService.getAllContacts(user.id, data);
  }

  @SkipThrottle()
  @Query(() => [Message])
  @UseGuards(GqlAuthGuard)
  getMessages(@CurrentUser() user: User, @Args('data') data: GetMessageInput) {
    data.userId = user.id;

    return this.messagesService.getContactMessages(data);
  }
}
