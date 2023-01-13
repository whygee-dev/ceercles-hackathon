import { Injectable } from '@nestjs/common';
import { User } from '@prisma/client';
import * as nodemailer from 'nodemailer';
import * as handlebars from 'handlebars';
import * as path from 'path';
import * as fs from 'fs/promises';
import { ConfigService } from '@nestjs/config';

type Email = {
  to: User;
  subject: string;
  variables: { [key: string]: string };
  template: string;
};

@Injectable()
export class EmailsService {
  constructor(private configService: ConfigService) {}

  async sendEmail(data: Email) {
    const filePath = path.join(process.cwd(), '/templates/' + data.template);
    const source = (await fs.readFile(filePath, 'utf-8')).toString();
    const template = handlebars.compile(source);
    const replacements = data.variables;
    const htmlToSend = template(replacements);

    const transporter = nodemailer.createTransport({
      service: 'Gmail',

      auth: {
        user: this.configService.get('GMAIL_USER'),
        pass: this.configService.get('GMAIL_PASS'),
      },
    });

    return transporter.sendMail({
      from: process.env.GMAIL_USER,
      to: data.to.email,
      subject: data.subject,

      html: htmlToSend,
    });
  }
}
