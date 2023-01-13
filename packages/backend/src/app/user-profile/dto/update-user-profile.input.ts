import { InputType, Field } from '@nestjs/graphql';
import { Gender } from '@prisma/client';
import { IsDate, IsOptional, MaxDate, MinDate } from 'class-validator';

@InputType()
export class UpdateUserProfileInput {
  @IsOptional()
  @Field({ nullable: true })
  userId: string;

  @IsOptional()
  @IsDate()
  @MaxDate(new Date(new Date().setFullYear(new Date().getFullYear() - 10)))
  @MinDate(new Date('1900-01-01'))
  @Field(() => Date, { nullable: true })
  birthday: Date;

  @IsOptional()
  @Field(() => Gender, { nullable: true })
  gender: Gender;

  @IsOptional()
  @Field()
  avatar: string;
}
