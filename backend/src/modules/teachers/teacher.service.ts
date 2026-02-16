import e from "express";
import prisma from "../../config/prisma";
import { AuthRequest } from "../../middlewares/auth.middleware";
import {
  CreateTeacherTypes,
  UpdateOldTeacherTypes,
  UpdateTeacherTypes,
} from "./teacher.types";
import userService from "../users/user.service";
import hasAccessService from "../has-access/has-access.service";

class TeacherService {
  async assign(data: CreateTeacherTypes) {
    return prisma.teacher.upsert({
      where: { userId: data.userId },
      update: {
        nip: data.nip,
        name: data.name,
        isActive: true,
      },
      create: {
        nip: data.nip,
        name: data.name,
        userId: data.userId,
        schoolId: data.schoolId,
      },
    });
  }

  async createTeacher(data: CreateTeacherTypes) {
    const { nip, name, email, schoolId } = data;

    return prisma.$transaction(async (tx) => {
      console.log(data);

      // 1️⃣ Cek email sudah pernah dipakai atau belum
      const alllowed = await tx.allowedEmail.findUnique({
        where: { email },
      });

      if (!alllowed) {
        throw new Error("Email not allowed");
      }

      const user = await tx.user.findUnique({
        where: { id: alllowed!.userId },
        include: { roles: { include: { role: true } } },
      });

      const hasRole = user?.roles.some((r) => r.role.name === "GURU");

      if (!hasRole) {
        const role = await tx.role.findUnique({
          where: { name: "GURU" },
        });

        await tx.userRole.create({
          data: {
            userId: user!.id,
            roleId: role!.id,
          },
        });
      }

      await tx.user.update({
        where: { id: alllowed!.userId },
        data: { isActive: true, name },
      });

      if (!user) {
        throw new Error("Failed to create user");
      }

      return await this.assign({
        ...data,
        userId: user.id,
        schoolId: data.schoolId,
      });
    });
  }

  async getAllTeachers(schoolId: string) {
    return prisma.teacher.findMany({
      where: { schoolId, isActive: true },
      include: {
        user: {
          select: {
            name: true,
            email: true,
            isActive: true,
          },
        },
      },
    });
  }

  async getTeacherById(id: string) {
    return prisma.teacher.findUnique({
      where: { id, isActive: true },
      include: {
        user: true,
      },
    });
  }

  async getMyTeacher(userId: string) {
    return prisma.teacher.findUnique({
      where: { userId, isActive: true },
    });
  }

  async updateOldTeacher(data: UpdateOldTeacherTypes) {
    const { userId, name } = data;

    return prisma.teacher.update({
      where: { userId },
      data: {
        isActive: true,
        name: name,
      },
    });
  }

  async updateTeacher(data: UpdateTeacherTypes) {
    return prisma.teacher.update({
      where: { id: data.id },
      data: {
        isActive: true,
        name: data.name,
        nip: data.nip,
      },
    });
  }

  async deleteTeacher(id: string) {
    return prisma.$transaction(async (tx) => {
      const teacher = await tx.teacher.findUnique({ where: { id } });

      if (!teacher) {
        throw new Error("Teacher not found");
      }

      return tx.teacher.update({
        where: { id },
        data: { isActive: false },
      });
    });
  }
}

export default new TeacherService();
