import { Field, ID, ObjectType } from '@nestjs/graphql';
import { UserProfile } from '../../user-profile/models/user-profile.model';

@ObjectType({ description: 'user' })
export class User {
  @Field(() => ID)
  id: string;

  @Field()
  fullname: string;

  @Field()
  email: string;

  @Field(() => Boolean)
  emailVerified: boolean;

  @Field(() => UserProfile, { nullable: true })
  profile: UserProfile;

  @Field(() => [User])
  contacts: User[];
}
