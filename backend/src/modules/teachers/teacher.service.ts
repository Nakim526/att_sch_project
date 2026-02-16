import e from "express";
import prisma from "../../config/prisma";
import { AuthRequest } from "../../middlewares/auth.middleware";
import { CreateTeacherTypes, UpdateTeacherTypes } from "./teacher.types";
import userService from "../users/user.service";

class TeacherService {
  async assign(data: CreateTeacherTypes) {
    return prisma.teacher.upsert({
      where: { nip: data.nip },
      update: {
        name: data.name,
        userId: data.userId,
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
    return prisma.$transaction(async (tx) => {
      console.log(data);

      const result = await userService.createUserTransaction(tx, {
        name: data.name,
        email: data.email!,
        userId: data.userId,
        roles: ["GURU"],
        schoolId: data.schoolId,
      });

      const user = result.user;

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

  async updateTeacher(id: string, data: UpdateTeacherTypes) {
    return prisma.teacher.update({
      where: { userId: id },
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
