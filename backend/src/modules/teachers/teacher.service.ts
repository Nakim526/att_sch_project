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

    const nipUsed = await tx.teacher.findUnique({
      where: { nip },
    });

    if (nipUsed && nipUsed.isActive && id !== nipUsed.id) {
      throw new Error("NIP already registered");
    }

    const teacher = await tx.teacher.findUnique({
      where: { userId },
    });

    if (teacher) {
      if (id !== teacher.id) {
        if (teacher.isActive) {
          throw new Error("Teacher already assigned");
        }

        return await tx.teacher.update({
          where: { userId },
          data: { name, nip, isActive: true },
        });
      }

      return await tx.teacher.update({
        where: { id },
        data: { name, nip, isActive: true },
      });
    }

    return false;
  }

  async createTeacher(data: CreateTeacherTypes) {
    return await prisma.$transaction(async (tx) => {
      return await this.createTeacherTransaction(tx, data);
    });
  }

  async createTeacherTransaction(
    tx: Prisma.TransactionClient,
    data: CreateTeacherTypes,
  ) {
    const { nip, name, email, schoolId } = data;

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

    const existed = await this.assign(tx, {
      ...data,
      id: null,
      userId: user.id,
      schoolId: data.schoolId,
    });

    if (!existed) {
      return await tx.teacher.create({
        data: {
          name,
          nip,
          userId: user.id,
          schoolId,
        },
      });
    }
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

      const user = await tx.user.findUnique({ where: { email: data.email } });

      if (!user) {
        throw new Error("User not found");
      }

      const existed = await this.assign(tx, {
        id: data.id,
        userId: user.id,
        name: data.name,
        nip: data.nip,
        schoolId: user.schoolId,
      });

      if (!existed) {
        await tx.teacher.update({
          where: { id: data.id },
          data: { isActive: false },
        })

        return await this.createTeacherTransaction(tx, {
          ...data,
          userId: user.id,
          schoolId: user.schoolId,
        });
      }

      return existed;
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
