import e from "express";
import prisma from "../../config/prisma";
import { AuthRequest } from "../../middlewares/auth.middleware";
import {
  AssignTeacherTypes,
  CreateTeacherTypes,
  UpdateOldTeacherTypes,
  UpdateTeacherTypes,
} from "./teacher.types";
import userService from "../users/user.service";
import hasAccessService from "../has-access/has-access.service";
import { Prisma } from "@prisma/client";

class TeacherService {
  async assign(tx: Prisma.TransactionClient, data: AssignTeacherTypes) {
    const { id, userId, name, nip, schoolId } = data;

    const existedByUser = await tx.teacher.findUnique({
      where: { userId },
    });

    if (existedByUser && id !== null) {
      if (existedByUser.isActive && id !== existedByUser.id) {
        throw new Error("Teacher already assigned");
      }

      await tx.teacher.update({
        where: { userId },
        data: { name, nip, isActive: true },
      });
    } else {
      const nipUsed = await tx.teacher.findUnique({
        where: { nip },
      });

      if (nipUsed) {
        throw new Error("NIP already registered");
      }

      await tx.teacher.create({
        data: { userId, name, nip, schoolId },
      });
    }
  }

  async createTeacher(data: CreateTeacherTypes) {
    const { nip, name, email, schoolId } = data;

    return await prisma.$transaction(async (tx) => {
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

      return await this.assign(tx, {
        ...data,
        id: null,
        userId: user.id,
        schoolId: data.schoolId,
      });
    });
  }

  async getAllTeachers(schoolId: string) {
    return await prisma.teacher.findMany({
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

  async getAllTeachersForce(schoolId: string) {
    return await prisma.teacher.findMany({
      where: { schoolId },
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
    return await prisma.teacher.findUnique({
      where: { id, isActive: true },
      include: {
        user: true,
      },
    });
  }

  async getMyTeacher(userId: string) {
    return await prisma.teacher.findUnique({
      where: { userId, isActive: true },
    });
  }

  async updateOldTeacher(
    tx: Prisma.TransactionClient,
    data: UpdateOldTeacherTypes,
  ) {
    const { userId, name } = data;

    const teacher = await tx.teacher.findUnique({ where: { userId } });

    if (!teacher) {
      throw new Error("Teacher not found");
    }

    return await tx.teacher.update({
      where: { userId },
      data: {
        isActive: true,
        name: name,
      },
    });
  }

  async updateTeacher(data: UpdateTeacherTypes) {
    return await prisma.$transaction(async (tx) => {
      const teacher = await tx.teacher.findUnique({ where: { id: data.id } });

      if (!teacher) {
        throw new Error("Teacher not found");
      }

      await this.assign(tx, {
        id: data.id,
        userId: teacher.userId,
        name: data.name,
        nip: data.nip,
        schoolId: teacher.schoolId,
      });
    });
  }

  async deleteTeacher(id: string) {
    return await prisma.$transaction(async (tx) => {
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
