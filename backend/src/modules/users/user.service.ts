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
      return await this.createUserTransaction(tx, schoolId, data);
    });
  }

  async createUserTransaction(
    tx: Prisma.TransactionClient,
    schoolId: string,
    data: CreateUserTypes,
  ) {
    console.log(`DATA: ${JSON.stringify(data)}`);
    await this.ensureAvailable(tx, schoolId, data.email);

    const user = await tx.user.create({
      data: {
        schoolId,
        name: data.name,
        email: data.email,
        avatar: data.avatar,
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

      const oldData = await tx.user.findUnique({
        where: { id },
        include: { roles: { select: { role: true } } },
      });

      if (!oldData) throw new Error("User tidak ditemukan");

      await this.assignRoles(tx, id, data.roles);

      if (
        oldData.roles.some((r) => r.role.name === RoleName.GURU) &&
        !data.roles.includes(RoleName.GURU)
      ) {
        await tx.teacher.update({
          where: { userId: id },
          data: { isActive: false },
        });
      }

      const user = await tx.user.update({
        where: { id },
        data: {
          name: data.name,
          email: data.email,
          avatar: data.avatar,
          isActive: data.isActive ?? true,
        },
      });

      await tx.allowedEmail.upsert({
        where: {
          schoolId_email: {
            schoolId: user.schoolId,
            email: oldData.email,
          },
        },
        update: { email: data.email },
        create: {
          userId: user.id,
          schoolId: user.schoolId,
          email: data.email,
        },
      });

      return user;
    });
  }

  async deleteUser(id: string, schoolId: string, userId: string) {
    return await prisma.$transaction(async (tx) => {
      const user = await tx.user.findUnique({ where: { id } });

      if (!user) throw new Error("User tidak ditemukan");

      const admin = await tx.user.findFirst({
        where: {
          id: userId,
          roles: {
            some: {
              role: {
                OR: [{ name: RoleName.ADMIN }, { name: RoleName.KEPSEK }],
              },
            },
          },
        },
      });

      const teacher = await tx.teacher.findUnique({
        where: { userId: id },
        include: { teachingAssignments: true, classAssignments: true },
      });

      if (teacher) {
        if (!admin) {
          const classAssignment = teacher.classAssignments.length > 0;
          const teachingAssignment = teacher.teachingAssignments.length > 0;

          if (classAssignment || teachingAssignment) {
            throw new Error(
              "Guru memiliki riwayat data, hubungi Kepala Sekolah Anda untuk menghapusnya",
            );
          }
        }

        await tx.classTeacherAssignment.deleteMany({
          where: { teacherId: teacher.id },
        });

        await tx.teachingAssignment.deleteMany({
          where: { teacherId: teacher.id },
        });

        await tx.teacher.delete({ where: { id: teacher.id } });
      }

      return await tx.user.delete({ where: { id, schoolId } });
    });
  }
}

export default new UserService();
