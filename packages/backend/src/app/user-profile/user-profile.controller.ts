import {
  Controller,
  Request,
  Post,
  UseGuards,
  UseInterceptors,
  UploadedFile,
  Get,
  StreamableFile,
} from '@nestjs/common';
import { FileInterceptor } from '@nestjs/platform-express';
import { SkipThrottle } from '@nestjs/throttler';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { MimeTypeFilter } from '../common/filters/mimetype.filter';
import { diskStorage } from 'multer';
import { cwd } from 'process';
import { createReadStream } from 'fs';
import { join } from 'path';
import { UserProfileService } from './user-profile.service';
import { ForbiddenError } from 'apollo-server-express';

const destination = join(cwd(), '/uploads/avatars/');

@Controller()
export class UserProfileController {
  constructor(private readonly userProfileService: UserProfileService) {}

  @SkipThrottle()
  @UseGuards(JwtAuthGuard)
  @UseInterceptors(
    FileInterceptor('avatar', {
      storage: diskStorage({
        destination,
        filename: (req, file, cb) => {
          const uniqueSuffix =
            Date.now() + '-' + Math.round(Math.random() * 1e9);
          cb(
            null,
            (req['user'] as any)?.id + '-' + uniqueSuffix + file.originalname
          );
        },
      }),
      limits: { fileSize: 2097152, files: 1 },
      fileFilter: MimeTypeFilter('image'),
    })
  )
  @Post('/upload/avatar')
  async uploadEvolutionImage(
    @Request() req,
    @UploadedFile() image: Express.Multer.File
  ) {
    if (!image) {
      throw new ForbiddenError('Invalid image');
    }

    return this.userProfileService.updateAvatar(req.user.id, image.filename);
  }

  @SkipThrottle()
  @UseGuards(JwtAuthGuard)
  @Get('/get-upload/avatar')
  async getEvolutionImage(@Request() req) {
    const { avatar } = await this.userProfileService.findAvatar(req.user.id);

    const file = createReadStream(join(destination, avatar));

    return new StreamableFile(file);
  }
}
