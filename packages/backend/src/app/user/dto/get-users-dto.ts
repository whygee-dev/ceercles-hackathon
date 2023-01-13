import { Field, InputType } from '@nestjs/graphql';
import { IsEmail, IsOptional, Length, Matches } from 'class-validator';

@InputType()
export class GetUsersDto {
  @IsOptional()
  @Field({ nullable: true })
  take: number;

  @IsOptional()
  @Field({ nullable: true })
  skip: number;

  @IsOptional()
  @Field({ nullable: true })
  emailSearch: string;

  @IsOptional()
  @Field({ nullable: true })
  fullnameSearch: string;
}
