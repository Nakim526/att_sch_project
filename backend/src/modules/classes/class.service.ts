// src/modules/class/class.service.ts

import { ClassTeacherRole, Prisma } from "@prisma/client";
import prisma from "../../config/prisma";
import {
  ClassTeacherAssignmentTypes,
  CreateClassTypes,
  UpdateClassTypes,
} from "./class.types";

class ClassService {
  async assignClassTeacher(
    tx: Prisma.TransactionClient,
    data: ClassTeacherAssignmentTypes,
  ) {
    await tx.classTeacherAssignment.deleteMany({
      where: { classId: data.classId },
    });

    return await tx.classTeacherAssignment.create({
      data: {
        class: { connect: { id: data.classId } },
        teacher: { connect: { id: data.teacherId } },
        role: data.role ?? ClassTeacherRole.HOMEROOM,
      },
    });
  }

  async create(schoolId: string, data: CreateClassTypes) {
    return await prisma.$transaction(async (tx) => {
      const class_ = await tx.class.create({
        data: {
          schoolId,
          name: data.name,
          gradeLevel: data.gradeLevel,
          academicYearId: data.academicYearId,
        },
      });

      if (data.teacherId) {
        await this.assignClassTeacher(tx, {
          classId: class_.id,
          teacherId: data.teacherId,
          role: data.role,
        });
      }

      return class_;
    });
  }

  async findAllBySchool(schoolId: string) {
    return await prisma.class.findMany({
      where: { schoolId },
      orderBy: [{ gradeLevel: "asc" }, { name: "asc" }],
    });
  }

  async findById(id: string) {
    return await prisma.class.findUnique({
      where: { id },
      include: { classTeachers: true },
    });
  }

  async update(id: string, schoolId: string, data: UpdateClassTypes) {
    return await prisma.$transaction(async (tx) => {
      if (data.teacherId) {
        await this.assignClassTeacher(tx, {
          classId: id,
          teacherId: data.teacherId,
          role: data.role,
        });
      } else {
        await tx.classTeacherAssignment.deleteMany({ where: { classId: id } });
      }

      return await tx.class.update({
        where: { id, schoolId },
        data: {
          name: data.name,
          gradeLevel: data.gradeLevel,
        },
      });
    });
  }

  async delete(id: string, schoolId: string) {
    return await prisma.class.delete({
      where: { id, schoolId },
    });
  }
}

export default new ClassService();
