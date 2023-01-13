import { Resolver, Mutation, Args } from '@nestjs/graphql';
import { UserProfileService } from './user-profile.service';
import { UserProfile } from './models/user-profile.model';
import { CreateUserProfileInput } from './dto/create-user-profile.input';
import { UpdateUserProfileInput } from './dto/update-user-profile.input';
import { GqlAuthGuard } from '../auth/guards/jwt-gql-auth.guard';
import { UseGuards } from '@nestjs/common';
import { CurrentUser } from '../graphql/current-user.decorator';
import { Role, User } from '@prisma/client';
import { RolesGuard } from '../auth/guards/roles.guard';
import { Roles } from '../auth/decorators/roles.decorator';

@Resolver(() => UserProfile)
export class UserProfileResolver {
  constructor(private readonly userProfileService: UserProfileService) {}

  @Mutation(() => UserProfile)
  @UseGuards(GqlAuthGuard)
  createUserProfile(
    @CurrentUser() user: User,
    @Args('data')
    data: CreateUserProfileInput
  ) {
    data.userId = user.id;

    return this.userProfileService.create(data);
  }

  @Mutation(() => UserProfile)
  @UseGuards(GqlAuthGuard)
  updateUserProfile(
    @CurrentUser() user: User,
    @Args('data')
    data: UpdateUserProfileInput
  ) {
    data.userId = user.id;

    return this.userProfileService.update(data);
  }

  @Mutation(() => UserProfile)
  @Roles(Role.ADMIN)
  @UseGuards(GqlAuthGuard, RolesGuard)
  sudoCreateUserProfile(
    @Args('data')
    data: UpdateUserProfileInput
  ) {
    return this.userProfileService.update(data);
  }

  @Mutation(() => UserProfile)
  @Roles(Role.ADMIN)
  @UseGuards(GqlAuthGuard, RolesGuard)
  sudoUpdateUserProfile(
    @Args('data')
    data: UpdateUserProfileInput
  ) {
    return this.userProfileService.update(data);
  }
}
