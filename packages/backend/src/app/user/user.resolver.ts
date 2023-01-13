import { UseGuards } from '@nestjs/common';
import { Args, ID, Mutation, Query, Resolver } from '@nestjs/graphql';
import { GqlAuthGuard } from '../auth/guards/jwt-gql-auth.guard';
import { RolesGuard } from '../auth/guards/roles.guard';
import { CurrentUser } from '../graphql/current-user.decorator';
import { CreateUserDto } from './dto/create-user.dto';
import { UpdateUserDto } from './dto/update-user.dto';
import { User } from './models/user.model';
import { UserService } from './user.service';
import { Role } from '@prisma/client';
import { Roles } from '../auth/decorators/roles.decorator';
import { GetUsersDto } from './dto/get-users-dto';
import { DeleteUserDto } from './dto/delete-user.dto';
import { ResetPasswordDto } from './dto/reset-password.dto';
import { Throttle } from '@nestjs/throttler';
import { GqlThrottlerGuard } from '../common/guards/GqlThottlerGuard.guard';
import { GqlEmailUnverifiedAuthGuard } from '../auth/guards/jwt-gql-email-unverified-auth.guard';
import { AllUsers } from './models/all-users.model';

@Resolver(() => User)
export class UserResolver {
  constructor(private readonly userService: UserService) {}

  @Query(() => User)
  @UseGuards(GqlEmailUnverifiedAuthGuard)
  whoAmI(@CurrentUser() user: User) {
    return this.userService.user(
      { id: user.id },
      {
        contacts: true,
        profile: true,
      }
    );
  }

  @Query(() => User)
  @Roles(Role.ADMIN)
  @UseGuards(GqlAuthGuard, RolesGuard)
  sudoWhoAmI(@Args('id', { type: () => ID }) id: string) {
    return this.userService.user(
      { id },
      {
        contacts: true,
      }
    );
  }

  @Mutation(() => User)
  createUser(@Args('data') data: CreateUserDto) {
    return this.userService.createUser(data);
  }

  @Mutation(() => User)
  @UseGuards(GqlAuthGuard)
  updateUser(@CurrentUser() user: User, @Args('data') data: UpdateUserDto) {
    return this.userService.updateUser({
      where: { id: user.id },
      data: { fullname: data.fullname },
    });
  }

  @Query(() => AllUsers)
  @Roles(Role.ADMIN)
  @UseGuards(GqlAuthGuard, RolesGuard)
  sudoGetAllUsers(@CurrentUser() user: User, @Args('data') data: GetUsersDto) {
    return this.userService.users(
      data.take,
      data.skip,
      data.emailSearch,
      data.fullnameSearch,
      user.id
    );
  }

  @Mutation(() => User)
  @UseGuards(GqlAuthGuard)
  deleteUser(@CurrentUser() user: User) {
    return this.userService.deleteUser({ id: user.id });
  }

  @Mutation(() => User)
  @Roles(Role.ADMIN)
  @UseGuards(GqlAuthGuard, RolesGuard)
  sudoUpdateUser(@Args('data') data: UpdateUserDto) {
    return this.userService.updateUser({ where: { id: data.id }, data });
  }

  @Mutation(() => User)
  @Roles(Role.ADMIN)
  @UseGuards(GqlAuthGuard, RolesGuard)
  sudoDeleteUser(@Args('data') data: DeleteUserDto) {
    return this.userService.deleteUser({ id: data.id });
  }

  @Mutation(() => Boolean)
  @Throttle(60, 1)
  @UseGuards(GqlThrottlerGuard)
  generatePasswordReset(@Args('email') email: string) {
    return this.userService.generatePasswordReset(email);
  }

  @Mutation(() => Boolean)
  @Roles(Role.ADMIN)
  @UseGuards(GqlAuthGuard, RolesGuard)
  sudoGeneratePasswordReset(@Args('email') email: string) {
    return this.userService.generatePasswordReset(email);
  }

  @Mutation(() => Boolean)
  resetPassword(@Args('data') data: ResetPasswordDto) {
    return this.userService.resetPassword(data.newPassword, data.token);
  }

  @Mutation(() => Boolean)
  @Throttle(60, 1)
  @UseGuards(GqlEmailUnverifiedAuthGuard, GqlThrottlerGuard)
  resendEmailConfirmation(@CurrentUser() user: User) {
    return this.userService.sendEmailConfirmation(user.id);
  }

  @Mutation(() => Boolean)
  @Roles(Role.ADMIN)
  @UseGuards(GqlAuthGuard, RolesGuard)
  sudoResendEmailConfirmation(@Args('userId') userId: string) {
    return this.userService.sendEmailConfirmation(userId);
  }

  @Mutation(() => Boolean)
  @UseGuards(GqlEmailUnverifiedAuthGuard)
  verifyEmail(@CurrentUser() user: User, @Args('token') token: string) {
    return this.userService.verifyEmail(user.id, token);
  }
}
