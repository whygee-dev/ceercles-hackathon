import { InputType, Field } from '@nestjs/graphql';
import { Gender } from '@prisma/client';
import { IsDate, MaxDate, MinDate } from 'class-validator';

@InputType()
export class CreateUserProfileInput {
  @Field({ nullable: true })
  userId: string;

  @IsDate()
  @MaxDate(new Date(new Date().setFullYear(new Date().getFullYear() - 10)))
  @MinDate(new Date('1900-01-01'))
  @Field(() => Date)
  birthday: Date;

  @Field(() => Gender)
  gender: Gender;
}
