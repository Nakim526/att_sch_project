import { RoleName } from "@prisma/client";
import prisma from "../../config/prisma";
import { signToken } from "../../utils/jwt";
import { parseEnum } from "../../utils/parser";
import { verifyGoogleToken } from "./google.service";

export async function loginWithGoogle(idToken: string, schoolName: string) {
  // 1️⃣ verify token ke Google
  const googleUser = await verifyGoogleToken(idToken);

  console.log("googleUser", googleUser);

  const school = await prisma.school.findUnique({
    where: { name: schoolName },
  });

  if (!school) {
    throw new Error("SCHOOL_NOT_FOUND");
  }

  // 2️⃣ allow-list
  const allowed = await prisma.allowedEmail.findUnique({
    where: {
      schoolId_email: {
        schoolId: school.id,
        email: googleUser.email,
      },
    },
  });

  if (!allowed || !allowed.isActive) {
    throw new Error("EMAIL_NOT_ALLOWED");
  }

  // 3️⃣ ambil user + role
  const user = await prisma.user.findUnique({
    where: { email: googleUser.email, id: allowed.userId },
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
