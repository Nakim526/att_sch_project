import prisma from "../../config/prisma";
import { AuthRequest } from "../../middlewares/auth.middleware";
import { CreateTeacherTypes } from "./teacher.types";

export async function createTeacher(data: CreateTeacherTypes) {
  return prisma.teacher.create({ data });
}

export async function getAllTeachers(schoolId: string) {
  return prisma.teacher.findMany({
    where: { schoolId, isActive: true },
    include: {
      user: { select: { email: true } },
    },
  });
}

export async function getMyTeacher(userId: string) {
  return prisma.teacher.findUnique({
    where: { userId },
  });
}
