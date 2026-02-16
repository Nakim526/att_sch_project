import prisma from "../../config/prisma";
import teacherService from "../teachers/teacher.service";
import userService from "../users/user.service";
import { CreateHasAccessTypes, UpdateHasAccessTypes } from "./has-access.types";

class HasAccessService {
  async createHasAccess(schoolId: string, payload: CreateHasAccessTypes) {
    const { name, email, roles } = payload;
    let user = null;

    return await prisma.$transaction(async (tx) => {
      // 1️⃣ Cek email sudah pernah dipakai atau belum
      const existed = await tx.allowedEmail.findUnique({
        where: { email },
      });

      if (existed) {
        user = await tx.user.findUnique({
          where: { id: existed.userId },
        });

        if (user?.isActive) {
          throw new Error("Email already allowed");
        }

        const userId = user!.id;

        await tx.user.update({
          where: { id: userId },
          data: { isActive: true },
        });

        // 3️⃣ Hapus semua role lama
        await tx.userRole.deleteMany({
          where: { userId },
        });

        // 4️⃣ Ambil roleId berdasarkan nama role
        const roleRecords = await tx.role.findMany({
          where: {
            name: { in: roles },
          },
        });

        // 5️⃣ Insert role baru
        await tx.userRole.createMany({
          data: roleRecords.map((role) => ({
            userId,
            roleId: role.id,
          })),
        });
      } else {
        const result = await userService.createUserTransaction(tx, {
          name,
          email,
          roles,
          schoolId,
        });

        user = result.user;
      }

      const userRoles = await tx.userRole.findMany({
        where: { userId: user!.id },
        select: { role: true },
      });

      for (const index in userRoles) {
        if ((userRoles[index].role.name = "GURU")) {
          await teacherService.assign({
            name,
            nip: undefined,
            email,
            userId: user!.id,
            schoolId,
          });
        }
      }

      // 5️⃣ TERAKHIR: simpan ke AllowedEmail
      await tx.allowedEmail.upsert({
        where: { email },
        update: { isActive: true, userId: user!.id },
        create: { email, userId: user!.id },
      });

      // 6️⃣ Return hasil (commit otomatis)
      return user;
    });
  }

  async getAllHasAccess() {
    return prisma.allowedEmail.findMany({
      where: { isActive: true },
      orderBy: { createdAt: "desc" },
      select: {
        id: true,
        isActive: true,
        createdAt: true,
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

  async getHasAccessById(id: string) {
    return prisma.allowedEmail.findUnique({
      where: { id, isActive: true },
      select: {
        id: true,
        isActive: true,
        createdAt: true,
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
  async updateHasAccess(id: string, schoolId: string, payload: UpdateHasAccessTypes) {
    const { name, email, roles } = payload;

    return prisma.$transaction(async (tx) => {
      // 1️⃣ Ambil allowed email dulu
      const allowed = await tx.allowedEmail.findUnique({
        where: { id },
      });

      if (!allowed) {
        throw new Error("Allowed email not found");
      }

      const userId = allowed.userId;

      // 2️⃣ Update user basic info
      await tx.user.update({
        where: { id: userId },
        data: {
          name,
          email,
          isActive: true,
        },
      });

      // 3️⃣ Hapus semua role lama
      await tx.userRole.deleteMany({
        where: { userId },
      });

      // 4️⃣ Ambil roleId berdasarkan nama role
      const roleRecords = await tx.role.findMany({
        where: {
          name: { in: roles },
        },
      });

      // 5️⃣ Insert role baru
      await tx.userRole.createMany({
        data: roleRecords.map((role) => ({
          userId,
          roleId: role.id,
        })),
      });

      const userRoles = await tx.userRole.findMany({
        where: { userId },
        select: { role: true },
      });

      for (const index in userRoles) {
        if ((userRoles[index].role.name = "GURU")) {
          await teacherService.assign({
            nip: undefined,
            name: String(name),
            email: String(email),
            userId,
            schoolId
          });
        }
      }

      // 6️⃣ Update allowed email jika perlu
      await tx.allowedEmail.update({
        where: { id },
        data: { email: email, isActive: true },
      });

      return { message: "User updated successfully" };
    });
  }

  async deleteHasAccess(id: string) {
    return prisma.$transaction(async (tx) => {
      const allowed = await tx.allowedEmail.findUnique({
        where: { id },
      });

      if (!allowed) {
        throw new Error("Allowed email not found");
      }

      // Nonaktifkan user
      await tx.user.update({
        where: { id: allowed.userId },
        data: { isActive: false },
      });

      await tx.teacher.update({
        where: { userId: allowed.userId },
        data: { isActive: false },
      })

      // Nonaktifkan allowed email
      await tx.allowedEmail.update({
        where: { id },
        data: { isActive: false },
      });

      return { message: "User access revoked" };
    });
  }
}

export default new HasAccessService();
