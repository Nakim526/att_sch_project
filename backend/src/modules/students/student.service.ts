// src/modules/student/student.service.ts

import prisma from "../../config/prisma";
import { CreateStudentTypes, UpdateStudentTypes } from "./student.types";

class StudentService {
  async create(schoolId: string, data: CreateStudentTypes) {
    return await prisma.$transaction(async (tx) => {
      const student = await tx.student.create({
        data: {
          name: data.name,
          nis: data.nis,
          schoolId,
          nisn: data.nisn,
          gender: data.gender,
          phone: data.phone,
          address: data.address,
        },
      });

      if (data.classId && data.semesterId)
        await tx.studentEnrollment.create({
          data: {
            studentId: student.id,
            classId: data.classId,
            semesterId: data.semesterId,
          },
        });

      return student;
    });
  }

  async findAllBySchool(schoolId: string) {
    return prisma.student.findMany({
      where: { schoolId },
      include: { enrollments: true },
    });
  }

  async findOneById(id: string) {
    return prisma.student.findUnique({
      where: { id },
      include: { enrollments: true },
    });
  }

  async findAllByClass(classId: string) {
    return prisma.studentEnrollment.findMany({
      where: { classId },
      orderBy: { student: { name: "asc" } },
    });
  }

  async findOneByClass(classId: string, id: string) {
    return prisma.studentEnrollment.findUnique({
      where: { id, classId },
      include: { student: true },
    });
  }

  async update(id: string, data: UpdateStudentTypes) {
    return await prisma.$transaction(async (tx) => {
      const student = await tx.student.update({
        where: { id },
        data: {
          name: data.name,
          nis: data.nis,
          nisn: data.nisn,
          gender: data.gender,
          phone: data.phone,
          address: data.address,
          isActive: true,
        },
      });

      await tx.studentEnrollment.updateMany({
        where: { studentId: id },
        data: { isActive: false },
      });

      if (data.classId && data.semesterId) {
        await tx.studentEnrollment.upsert({
          where: {
            studentId_semesterId: {
              studentId: id,
              semesterId: data.semesterId,
            },
          },
          update: {
            studentId: student.id,
            classId: data.classId,
            semesterId: data.semesterId,
            isActive: true,
          },
          create: {
            studentId: student.id,
            classId: data.classId,
            semesterId: data.semesterId,
          },
        });
      }

      return student;
    });
  }

  async softDelete(id: string) {
    return await prisma.$transaction(async (tx) => {
      const student = await tx.student.update({
        where: { id },
        data: { isActive: false },
      });

      const enrollments = await tx.studentEnrollment.findMany({
        where: { studentId: id },
      });

      for (const { id } of enrollments) {
        await tx.studentEnrollment.update({
          where: { id },
          data: { isActive: false },
        });
      }

      return student;
    });
  }

  async hardDelete(id: string) {
    return prisma.student.delete({
      where: { id },
    });
  }
}

export default new StudentService();
