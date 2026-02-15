import prisma from "../../config/prisma";
import { AuthRequest } from "../../middlewares/auth.middleware";
import { createUserTransaction } from "../users/user.service";
import { CreateHasAccessTypes } from "./has-access.types";

export async function createHasAccess(input: CreateHasAccessTypes) {
  const { schoolId, name, email, roles } = input;

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
      isActive: true,
      user: {
        select: {
          id: true,
          name: true,
          email: true,
          schoolId: true,
          roles: {
            include: {
              role: true,
            },
          },
        },
      },
    },
  });
}
