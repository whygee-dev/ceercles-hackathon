import { Field } from '@nestjs/graphql';
import { IsNotEmpty, Length } from 'class-validator';

export class CreateMessageDto {
  @IsNotEmpty()
  @Length(1, 250)
  @Field()
  text: string;

  @IsNotEmpty()
  @Field()
  receiverId: string;
}
