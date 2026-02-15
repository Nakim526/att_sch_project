import prisma from "../../config/prisma";
import { AuthRequest } from "../../middlewares/auth.middleware";
import { createUserTransaction } from "../users/user.service";
import { CreateAccessTypes } from "./access.types";

export async function createAccess(input: CreateAccessTypes) {
  const { schoolId, name, email, roles } = input;

  return await prisma.$transaction(async (tx) => {
    // 1️⃣ Cek email sudah pernah dipakai atau belum
    const allowed = await tx.allowedEmail.findUnique({
      where: { email },
    });

    if (allowed) {
      throw new Error("Email already allowed");
    }

    const user = await createUserTransaction(tx, {
      name,
      email,
      roles,
      schoolId,
    });

    // 5️⃣ TERAKHIR: simpan ke AllowedEmail
    await tx.allowedEmail.create({
      data: {
        email,
        user.id
      },
    });

    // 6️⃣ Return hasil (commit otomatis)
    return user;
  });
}

export async function getAllAccess() {
  return prisma.allowedEmail.findMany(
    {
      orderBy: {
        createdAt: "desc",
      },
      select: {
        
      },
    }
  );
}
