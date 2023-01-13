import { Field, InputType } from '@nestjs/graphql';
import { IsOptional } from 'class-validator';

@InputType()
export class GetAllContactsInput {
  @IsOptional()
  @Field({ nullable: true, defaultValue: 20 })
  take: number;

  @IsOptional()
  @Field({ nullable: true, defaultValue: 0 })
  skip: number;

  @IsOptional()
  @Field({ nullable: true, defaultValue: '' })
  search: string;
}
