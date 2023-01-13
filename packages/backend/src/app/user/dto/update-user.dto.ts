import { Field, InputType } from '@nestjs/graphql';
import { IsEmail, IsOptional, Length, Matches } from 'class-validator';

@InputType()
export class UpdateUserDto {
  @IsOptional()
  @Field({ nullable: true, description: 'Only used for admins' })
  id: string;

  @IsOptional()
  @Matches(
    /(^[A-Za-z]{2,16})([ ]{0,1})([A-Za-z]{2,16})?([ ]{0,1})?([A-Za-z]{2,16})?([ ]{0,1})?([A-Za-z]{2,16})/,
  )
  @Field({ nullable: true })
  fullname: string;

  @IsOptional()
  @IsEmail()
  @Field({ nullable: true })
  email: string;

  @IsOptional()
  @Length(8, 256, {
    message: 'Password length must be between 8 and 256 characters',
  })
  @Field({ nullable: true })
  password: string;
}
