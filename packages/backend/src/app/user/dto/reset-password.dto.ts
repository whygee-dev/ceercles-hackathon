import { Field, InputType } from '@nestjs/graphql';
import { Length } from 'class-validator';

@InputType()
export class ResetPasswordDto {
  @Field({ nullable: true, description: 'Only used for admins' })
  userId: string;

  @Length(8, 256, {
    message: 'Password length must be between 8 and 256 characters',
  })
  @Field()
  newPassword: string;

  @Field()
  token: string;
}
