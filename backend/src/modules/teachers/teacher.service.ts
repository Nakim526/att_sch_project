import e from "express";
import prisma from "../../config/prisma";
import { AuthRequest } from "../../middlewares/auth.middleware";
import { CreateTeacherTypes } from "./teacher.types";
import { createUser } from "../users/user.service";

export async function createTeacher(data: CreateTeacherTypes) {
  // pastikan school ada
  console.log(data.schoolId);

  const school = await prisma.school.findUnique({
    where: { id: data.schoolId },
  });

  if (!school) {
    throw new Error("School tidak ditemukan");
  }

  return prisma.$transaction(async (tx) => {
    let user = null;

    if (data.userId) {
      user = await tx.user.findUnique({
        where: { id: data.userId },
      });
    }

    if (!user) {
      console.log(data);

      if (!data.email) {
        throw new Error("Email harus diisi");
      }

      user = await createUser(tx, {
        name: data.name,
        email: data.email!,
        roles: ["GURU"],
        schoolId: data.schoolId,
      });
    }

    return tx.teacher.create({
      data: {
        nip: data.nip,
        name: data.name,
        userId: user.id,
        schoolId: data.schoolId,
      },
    });
  });
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
