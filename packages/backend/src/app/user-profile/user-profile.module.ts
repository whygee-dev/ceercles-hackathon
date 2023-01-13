import { Module } from '@nestjs/common';
import { UserProfileService } from './user-profile.service';
import { UserProfileResolver } from './user-profile.resolver';
import { UserModule } from '../user/user.module';
import { UserProfileController } from './user-profile.controller';

@Module({
  imports: [UserModule],
  controllers: [UserProfileController],
  providers: [UserProfileResolver, UserProfileService],
  exports: [UserProfileService],
})
export class UserProfileModule {}
