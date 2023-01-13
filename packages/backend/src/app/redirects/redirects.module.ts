import { Module } from '@nestjs/common';
import { RedirectsService } from './redirects.service';
import { RedirectsController } from './redirects.controller';

@Module({
  controllers: [RedirectsController],
  providers: [RedirectsService]
})
export class RedirectsModule {}
