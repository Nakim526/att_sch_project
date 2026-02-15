import prisma from "../../config/prisma";
import { signToken } from "../../utils/jwt";
import { verifyGoogleToken } from "./google.service";

export async function loginWithGoogle(idToken: string) {
  // 1️⃣ verify token ke Google
  const googleUser = await verifyGoogleToken(idToken);

  // 2️⃣ allow-list
  const allowed = await prisma.allowedEmail.findUnique({
    where: { email: googleUser.email },
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
