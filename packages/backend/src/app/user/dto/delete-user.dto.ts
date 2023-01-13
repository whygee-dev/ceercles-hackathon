import { Field, InputType } from '@nestjs/graphql';
import { IsOptional } from 'class-validator';

@InputType()
export class DeleteUserDto {
  @IsOptional()
  @Field({ nullable: true, description: 'Only used for admins' })
  id: string;
}
