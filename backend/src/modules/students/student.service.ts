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
        classId: data.classId,
      },
    });
  }

  async findAllBySchool(schoolId: string) {
    return prisma.student.findMany({
      where: { schoolId },
      include: {
        class: {
          select: { id: true, name: true, grade: true },
        },
      },
    });
  }

  async findByClass(classId: string) {
    return prisma.student.findMany({
      where: { classId },
      orderBy: { name: "asc" },
    });
  }

  async findById(id: string) {
    return prisma.student.findUnique({
      where: { id },
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
