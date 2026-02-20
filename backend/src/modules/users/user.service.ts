import { Prisma, RoleName } from "@prisma/client";
import prisma from "../../config/prisma";
import { AuthRequest } from "../../middlewares/auth.middleware";
import { CreateUserTypes, UpdateUserTypes } from "./user.types";

class UserService {
  async anyUsed(tx: Prisma.TransactionClient, email: string) {
    const users = await tx.user.findMany({
      where: { email },
    });

    let self = true;

    if (users.length > 0) {
      self = users.some((u) => u.email === email);
    }

    if (!self) {
      throw new Error(`Email ${email} sudah digunakan`);
    }

    return self;
  }

  async assignRoles(
    tx: Prisma.TransactionClient,
    userId: string,
    newRoles: RoleName[],
  ) {
    // hapus user role lama
    await tx.userRole.deleteMany({ where: { userId } });

    // ambil roleId berdasarkan roles baru
    const roles = await tx.role.findMany({
      where: { name: { in: newRoles } },
    });

    if (roles.length !== newRoles.length) {
      throw new Error("Salah satu role tidak ditemukan");
    }

    // assign roles
    await tx.userRole.createMany({
      data: roles.map((r) => ({
        userId,
        roleId: r.id,
      })),
    });
  }

  async createUser(schoolId: string, data: CreateUserTypes) {
    return await prisma.$transaction(async (tx) => {
      await this.anyUsed(tx, data.email);

      const user = await tx.user.upsert({
        where: { email: data.email },
        update: {
          schoolId,
          name: data.name,
          isActive: true,
        },
        create: {
          name: data.name,
          email: data.email,
          schoolId,
        },
      });

      await this.assignRoles(tx, user.id, data.roles);

      await tx.allowedEmail.create({
        data: {
          schoolId,
          email: data.email,
          userId: user.id,
        },
      });

      return user;
    });
  }

  async readAllUsers(schoolId: string) {
    return await prisma.user.findMany({
      where: { schoolId },
      include: { roles: { select: { role: true } } },
    });
  }

  async readUserById(id: string) {
    return await prisma.user.findUnique({
      where: { id },
      include: { roles: { select: { role: true } } },
    });
  }

  async readUserSelf(id: string) {
    return await prisma.user.findUnique({
      where: { id },
      include: { roles: { select: { role: true } } },
    });
  }

  async updateUser(id: string, data: UpdateUserTypes) {
    return await prisma.$transaction(async (tx) => {
      await this.anyUsed(tx, data.email);

      await this.assignRoles(tx, id, data.roles);

      const user = await tx.user.update({
        where: { id },
        data: {
          name: data.name,
          email: data.email,
          avatar: data.avatar,
          isActive: data.isActive,
        },
      });

      await tx.allowedEmail.update({
        where: { userId: id },
        data: { email: data.email },
      });

      return user;
    });
  }

  async deleteUser(id: string) {
    return await prisma.user.delete({ where: { id } });
  }

}

export default new UserService();
