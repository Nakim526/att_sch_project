import { Prisma } from "@prisma/client";
import prisma from "../../config/prisma";
import { AuthRequest } from "../../middlewares/auth.middleware";
import { CreateUserTypes } from "./user.types";

class UserService {
  async createUser(data: CreateUserTypes) {
    return prisma.$transaction(async (tx) => {
      return this.createUserTransaction(tx, data);
    });
  }

  async createUserTransaction(
    tx: Prisma.TransactionClient,
    data: CreateUserTypes,
  ) {
    const user = await tx.user.upsert({
      where: { email: data.email },
      update: {
        isActive: true,
      },
      create: {
        name: data.name,
        email: data.email,
        schoolId: data.schoolId,
      },
    });

    // 3. ambil semua role sekaligus
    const roles = await tx.role.findMany({
      where: {
        name: { in: data.roles },
      },
    });

    if (roles.length !== data.roles.length) {
      throw new Error("Salah satu role tidak ditemukan");
    }

    // 4. assign roles (bulk)
    await tx.userRole.createMany({
      data: roles.map((role) => ({
        userId: user.id,
        roleId: role.id,
      })),
      skipDuplicates: true, // aman kalau role dobel
    });

    return { user, roles };
  }

  async getAllUsers(schoolId: string) {
    return prisma.user.findMany({
      where: { schoolId, isActive: true },
      include: {
        roles: {
          include: {
            role: true,
          },
        },
      },
      orderBy: {
        createdAt: "desc",
      },
    });
  }

  async getMyUser(id: string) {
    return prisma.user.findUnique({
      where: { id },
      include: {
        roles: {
          include: {
            role: true,
          },
        },
        school: true,
      },
    });
  }
}

export default new UserService();