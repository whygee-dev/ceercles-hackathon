import { ObjectType, Field, registerEnumType } from '@nestjs/graphql';
import { Gender } from '@prisma/client';

@ObjectType()
export class UserProfile {
  @Field()
  userId: string;

  @Field({ nullable: true })
  avatar?: string;

  @Field(() => Date)
  birthday: Date;

  @Field(() => Gender)
  gender: Gender;
}

registerEnumType(Gender, {
  name: 'Gender',
});
