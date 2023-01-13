import { Field, ID, ObjectType } from '@nestjs/graphql';
import { Message } from '../../messages/model/message.model';

@ObjectType({ description: 'user' })
export class UserMin {
  @Field(() => ID)
  id: string;

  @Field()
  fullname: string;

  @Field(() => Message, { nullable: true })
  lastMessage: Message;
}
