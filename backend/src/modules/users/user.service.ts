import { Prisma } from "@prisma/client";
import prisma from "../../config/prisma";
import { AuthRequest } from "../../middlewares/auth.middleware";
import { CreateUserTypes } from "./user.types";

export async function createUser(data: CreateUserTypes) {
  return prisma.$transaction(async (tx) => {
    return createUserTransaction(tx, data);
  });
}

export async function createUserTransaction(
  tx: Prisma.TransactionClient,
  data: CreateUserTypes,
) {
  let user = null;

  if (data.userId) {
    user = await tx.user.findUnique({
      where: { id: data.userId },
    });
  }

  // 2. create user
  if (!user) {
    user = await tx.user.create({
      data: {
        name: data.name,
        email: data.email,
        schoolId: data.schoolId,
      },
    });
  }

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

export async function getAllUsers(schoolId: string) {
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

export async function getMyUser(id: string) {
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
