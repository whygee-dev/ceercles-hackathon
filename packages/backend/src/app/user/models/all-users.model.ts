import { Field, ObjectType } from '@nestjs/graphql';
import { User } from './user.model';

@ObjectType({ description: 'user' })
export class AllUsers {
  @Field(() => [User])
  users: User[];

  @Field()
  count: number;
}
