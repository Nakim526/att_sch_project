import prisma from "../../config/prisma";
import { createUserTransaction } from "../users/user.service";
import { CreateHasAccessTypes, UpdateHasAccessTypes } from "./has-access.types";

export async function createHasAccess(
  schoolId: string,
  payload: CreateHasAccessTypes,
) {
  const { name, email, roles } = payload;

  return await prisma.$transaction(async (tx) => {
    // 1️⃣ Cek email sudah pernah dipakai atau belum
    const allowed = await tx.allowedEmail.findUnique({
      where: { email },
    });

    if (allowed) {
      throw new Error("Email already allowed");
    }

    const result = await createUserTransaction(tx, {
      name,
      email,
      roles,
      schoolId,
    });

    const user = result.user;

    // 5️⃣ TERAKHIR: simpan ke AllowedEmail
    await tx.allowedEmail.create({
      data: {
        email,
        userId: user.id,
      },
    });

    // 6️⃣ Return hasil (commit otomatis)
    return user;
  });
}

export async function getAllHasAccess() {
  return prisma.allowedEmail.findMany({
    select: {
      id: true,
      isActive: true,
      user: {
        select: {
          id: true,
          name: true,
          email: true,
          schoolId: true,
          roles: {
            select: {
              role: true,
            },
          },
        },
      },
    },
  });
}

export async function getHasAccessById(id: string) {
  return prisma.allowedEmail.findUnique({
    where: { id },
    select: {
      id: true,
      isActive: true,
      user: {
        include: {
          roles: {
            select: {
              role: true,
            },
          },
        },
      },
    },
  });
}

export async function updateHasAccess(
  id: string,
  payload: UpdateHasAccessTypes,
) {
  const { email } = payload;

  return prisma.$transaction(async (tx) => {
    // 1️⃣ Cek email sudah pernah dipakai atau belum
    const allowed = await tx.allowedEmail.findUnique({
      where: { email },
    });

    if (allowed) {
      throw new Error("Email already allowed");
    }

    return await tx.allowedEmail.update({
      where: { id },
      data: payload,
    });
  });
}

export async function deleteHasAccess(id: string) {
  return prisma.allowedEmail.delete({
    where: { id },
  });
}
