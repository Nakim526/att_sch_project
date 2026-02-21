import { Prisma, RoleName } from "@prisma/client";
import prisma from "../../config/prisma";
import { AuthRequest } from "../../middlewares/auth.middleware";
import { CreateUserTypes, UpdateUserTypes } from "./user.types";

class UserService {
  async ensureAvailable(
    tx: Prisma.TransactionClient,
    schoolId: string,
    email: string,
    userId?: string,
  ) {
    const used = await tx.user.findFirst({
      where: {
        schoolId,
        email,
        ...(userId && { id: { not: userId } }),
      },
    });

    if (used) {
      throw new Error(`Email ${email} sudah digunakan`);
    }
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
      await this.ensureAvailable(tx, schoolId, data.email);

      const user = await tx.user.create({
        data: {
          schoolId,
          name: data.name,
          email: data.email,
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

  async readUserList(schoolId: string) {
    return await prisma.user.findMany({
      where: { schoolId },
      include: { roles: { select: { role: true } } },
    });
  }

  async readUserDetail(id: string) {
    return await prisma.user.findUnique({
      where: { id },
      include: { roles: { select: { role: true } } },
    });
  }

  async updateUser(id: string, schoolId: string, data: UpdateUserTypes) {
    return await prisma.$transaction(async (tx) => {
      await this.ensureAvailable(tx, schoolId, data.email, id);

      await this.assignRoles(tx, id, data.roles);

      const oldData = await tx.user.findUnique({ where: { id } });

      if (!oldData) throw new Error("User tidak ditemukan");

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
        where: {
          schoolId_email: {
            schoolId: user.schoolId,
            email: oldData.email,
          },
        },
        data: { email: data.email },
      });

      return user;
    });
  }

  async deleteUser(id: string, schoolId: string) {
    return await prisma.user.delete({ where: { id, schoolId } });
  }
}

export default new UserService();
