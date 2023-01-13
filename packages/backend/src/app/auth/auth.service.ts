import { Injectable } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { UserService } from '../user/user.service';
import * as bcrypt from 'bcrypt';
import { Role, User } from '@prisma/client';

@Injectable()
export class AuthService {
  constructor(
    private usersService: UserService,
    private jwtService: JwtService
  ) {}

  async validateUser(
    email: string,
    password: string
  ): Promise<Omit<User, 'password'> | null> {
    const user = await this.usersService.user({ email });

    if (user && (await bcrypt.compare(password, user.password))) {
      const { password, ...result } = user;

      return result;
    }
    return null;
  }

  async validateAdmin(
    email: string,
    password: string
  ): Promise<Omit<User, 'password'> | null> {
    const user = await this.usersService.user({ email });

    if (!user || !user.roles.includes(Role.ADMIN)) return null;

    if (await bcrypt.compare(password, user.password)) {
      const { password, ...result } = user;

      return result;
    }

    return null;
  }

  async login(user: Omit<User, 'password'>) {
    const payload = {
      id: user.id,
      email: user.email,
      fullname: user.fullname,
      sub: user.id,
      roles: user.roles,
    };

    console.log('user', user);

    return {
      accessToken: this.jwtService.sign(payload),
    };
  }

  verify(token: string) {
    try {
      return this.jwtService.verify(token);
    } catch (error) {
      return false;
    }
  }
}
