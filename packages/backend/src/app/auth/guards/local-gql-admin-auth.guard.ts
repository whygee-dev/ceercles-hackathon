import { ExecutionContext, Injectable } from '@nestjs/common';
import { GqlExecutionContext } from '@nestjs/graphql';
import { AuthGuard } from '@nestjs/passport';

@Injectable()
export class GqlAdminLocalAuth extends AuthGuard('local-admin') {
  getRequest(context: ExecutionContext) {
    const ctx = GqlExecutionContext.create(context);
    const gqlReq = ctx.getContext().req;

    if (gqlReq) {
      const { data } = ctx.getArgs();
      gqlReq.body = data;
      return gqlReq;
    }

    return context.switchToHttp().getRequest();
  }
}
