import { CanActivate, Injectable } from '@nestjs/common';
import { AuthService } from '../auth.service';

@Injectable()
export class WsAuthGuard implements CanActivate {
  constructor(private readonly authService: AuthService) {}

  canActivate(context: any): boolean | any | Promise<boolean | any> {
    const token = context.args[0].handshake.headers.authorization.split(' ')[1];

    return this.authService.verify(token);
  }
}
