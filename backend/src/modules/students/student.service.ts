// src/modules/student/student.service.ts

import { Prisma } from "@prisma/client";
import prisma from "../../config/prisma";
import {
  CreateStudentTypes,
  StudentEnrollmentTypes,
  UpdateStudentTypes,
} from "./student.types";

class StudentService {
  async ensureAvailable(
    tx: Prisma.TransactionClient,
    schoolId: string,
    nis: string,
    studentId?: string,
  ) {
    const used = await tx.student.findFirst({
      where: { schoolId, nis, ...(studentId && { id: { not: studentId } }) },
    });

    if (used) throw new Error(`NIS ${nis} sudah digunakan`);
  }

  async assignStudent(
    tx: Prisma.TransactionClient,
    studentId: string,
    data: StudentEnrollmentTypes,
  ) {
    await tx.studentEnrollment.upsert({
      where: {
        studentId_semesterId: {
          studentId,
          semesterId: data.semesterId,
        },
      },
      update: { classId: data.classId },
      create: {
        studentId: studentId,
        classId: data.classId,
        semesterId: data.semesterId,
      },
    });
  }

  async create(schoolId: string, data: CreateStudentTypes) {
    return await prisma.$transaction(async (tx) => {
      await this.ensureAvailable(tx, schoolId, data.nis);

      const student = await tx.student.create({
        data: {
          schoolId,
          nis: data.nis,
          name: data.name,
          gender: data.gender,
          phone: data.phone,
          address: data.address,
        },
      });

      if (data.classId && data.semesterId)
        await this.assignStudent(tx, student.id, {
          classId: data.classId,
          semesterId: data.semesterId,
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

  async findOneById(id: string, schoolId: string) {
    return prisma.student.findUnique({
      where: { id, schoolId },
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

  async update(id: string, schoolId: string, data: UpdateStudentTypes) {
    return await prisma.$transaction(async (tx) => {
      await this.ensureAvailable(tx, data.nis, id);

      const student = await tx.student.update({
        where: { id, schoolId },
        data: {
          nis: data.nis,
          name: data.name,
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

      if (data.classId && data.semesterId)
        await this.assignStudent(tx, student.id, {
          classId: data.classId,
          semesterId: data.semesterId,
        });

      return student;
    });
  }

  async softDelete(id: string, schoolId: string) {
    return await prisma.$transaction(async (tx) => {
      const student = await tx.student.update({
        where: { id, schoolId },
        data: { isActive: false },
      });

      await tx.studentEnrollment.updateMany({
        where: { studentId: id },
        data: { isActive: false },
      });

      return student;
    });
  }

  async hardDelete(id: string, schoolId: string) {
    return prisma.student.delete({
      where: { id, schoolId },
    });
  }
}

export default new StudentService();
