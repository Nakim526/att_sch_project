// src/modules/student/student.service.ts

import prisma from "../../config/prisma";
import { CreateStudentTypes, UpdateStudentTypes } from "./student.types";

class StudentService {
  async create(schoolId: string, data: CreateStudentTypes) {
    return prisma.student.create({
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
  }

  async findAllBySchool(schoolId: string) {
    return prisma.student.findMany({
      where: { schoolId },
      select: { enrollments: true },
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
    });
  }

  async update(id: string, data: UpdateStudentTypes) {
    return prisma.student.update({
      where: { id },
      data,
    });
  }

  async delete(id: string) {
    return prisma.student.delete({
      where: { id },
    });
  }
}

export default new StudentService();
