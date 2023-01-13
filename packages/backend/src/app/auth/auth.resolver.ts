import { UseGuards } from '@nestjs/common';
import { Args, Context, Mutation, Resolver } from '@nestjs/graphql';
import { Role } from '@prisma/client';
import { AuthService } from './auth.service';
import { Roles } from './decorators/roles.decorator';
import { LoginInput } from './dto/login.dto';
import { GqlAdminLocalAuth } from './guards/local-gql-admin-auth.guard';
import { GqlLocalAuth } from './guards/local-gql-auth.guard';
import { RolesGuard } from './guards/roles.guard';
import { Auth } from './models/auth.model';

@Resolver(() => Auth)
export class AuthResolver {
  constructor(private authService: AuthService) {}

  @UseGuards(GqlLocalAuth)
  @Mutation(() => Auth, { nullable: true })
  login(
    @Args('data')
    data: LoginInput,
    @Context() context: any,
  ) {
    return this.authService.login(context.req.user);
  }

  @UseGuards(GqlAdminLocalAuth)
  @Mutation(() => Auth, { nullable: true })
  sudoLogin(
    @Args('data')
    data: LoginInput,
    @Context() context: any,
  ) {
    return this.authService.login(context.req.user);
  }
}
