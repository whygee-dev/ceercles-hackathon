import { Controller, Get, Param, Query, Res } from '@nestjs/common';
import { SkipThrottle } from '@nestjs/throttler';
import { RedirectsService } from './redirects.service';

@Controller('redirects')
export class RedirectsController {
  constructor(private readonly redirectsService: RedirectsService) {}

  @SkipThrottle()
  @Get('/deep-link/:path')
  deeplink(@Query() query, @Param('path') path: string, @Res() res) {
    const queries = new URLSearchParams(query);

    console.log(
      `Redirecting to: ${process.env.DEEPLINK}/${path}?${queries.toString()}`,
    );

    return res.redirect(
      `${process.env.DEEPLINK}/${path}?${queries.toString()}`,
    );
  }
}
