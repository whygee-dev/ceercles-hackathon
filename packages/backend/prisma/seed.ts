import { Prisma, PrismaClient, Role } from '@prisma/client';
import * as bcrypt from 'bcrypt';

const prisma = new PrismaClient();

async function main() {
  const password = await bcrypt.hash('Adminadmin123', 11);
  const usersData: Prisma.UserCreateInput[] = [
    {
      email: 'admin@gmail.com',
      fullname: 'Admin',
      password,
      emailVerified: true,
      roles: [Role.ADMIN],
      banned: false,
      deleted: false,
    },
    {
      email: 'deleted@ceercles.com',
      fullname: 'Utilisateur supprimé',
      password: Date.now() + '-' + Math.round(Math.random() * 1e9),
      emailVerified: false,
      roles: [Role.DELETED_USER],
      banned: true,
      deleted: true,
    },
  ];

  const promises = usersData.map((userData) => {
    return prisma.user.create({
      data: {
        email: userData.email,
        fullname: userData.fullname,
        password: userData.password,
        roles: userData.roles,
        emailVerified: userData.emailVerified,
        banned: userData.banned,
        deleted: userData.deleted,
      },
    });
  });

  await Promise.all(promises);
}

main()
  .catch((e) => {
    throw e;
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
