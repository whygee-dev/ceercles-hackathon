import { ObjectType, Field, GraphQLISODateTime, ID } from '@nestjs/graphql';
import { UserMin } from '../../user/models/user-min.model';

@ObjectType()
export class Message {
  @Field(() => ID)
  id: string;

  @Field()
  text: string;

  @Field(() => UserMin)
  sender: UserMin;

  @Field(() => UserMin)
  receiver: UserMin;

  @Field(() => GraphQLISODateTime)
  createdAt: Date;
}
