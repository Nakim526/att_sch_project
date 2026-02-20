import { RoleName } from "@prisma/client";
import prisma from "../../config/prisma";
import { signToken } from "../../utils/jwt";
import { parseEnum } from "../../utils/parser";
import { verifyGoogleToken } from "./google.service";

export async function loginWithGoogle(idToken: string, schoolId: string) {
  // 1️⃣ verify token ke Google
  const googleUser = await verifyGoogleToken(idToken);

  console.log("googleUser", googleUser);

  // 2️⃣ allow-list
  const allowed = await prisma.allowedEmail.findUnique({
    where: {
      schoolId_email: {
        schoolId,
        email: googleUser.email,
      },
    },
  });

  if (!allowed || !allowed.isActive) {
    throw new Error("EMAIL_NOT_ALLOWED");
  }

  // 3️⃣ ambil user + role
  const user = await prisma.user.findUnique({
    where: { email: googleUser.email },
    include: {
      roles: { include: { role: true } },
      school: true,
    },
  });

  if (!user || !user.isActive) {
    throw new Error("USER_NOT_FOUND");
  }

  console.log("user", user);

  // 4️⃣ JWT payload
  const payload = {
    id: user.id,
    email: user.email,
    roles: user.roles.map((r) => r.role.name),
    schoolId: user.schoolId,
  };

  console.log("payload", payload);

  const token = signToken(payload);

  return {
    token,
    user: payload,
  };
}
