import { Field, InputType } from '@nestjs/graphql';
import { IsOptional } from 'class-validator';

@InputType()
export class GetMessageInput {
  @IsOptional()
  @Field({ nullable: true, defaultValue: 20 })
  take: number;

  @IsOptional()
  @Field({ nullable: true, defaultValue: 0 })
  skip: number;

  @Field()
  contactId: string;

  @Field({ nullable: true, description: 'Only used for admins' })
  userId: string;
}
