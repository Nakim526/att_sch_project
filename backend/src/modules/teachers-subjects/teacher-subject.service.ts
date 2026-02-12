// src/modules/teacher-subject/teacher-subject.service.ts

import prisma from "../../config/prisma";
import { CreateTeacherSubjectTypes } from "./teacher-subject.types";

class TeacherSubjectService {
  async assign(data: CreateTeacherSubjectTypes) {
    return prisma.teacherSubject.create({
      data: {
        teacherId: data.teacherId,
        subjectId: data.subjectId,
        classId: data.classId,
      },
    });
  }

  async findAllBySchool(schoolId: string) {
    return prisma.teacherSubject.findMany({
      where: {
        class: {
          schoolId,
        },
      },
      include: {
        teacher: {
          select: { id: true, name: true, user: { select: { email: true } } },
        },
        subject: {
          select: { id: true, name: true },
        },
        class: {
          select: { id: true, name: true, grade: true },
        },
      },
    });
  }

  async findByTeacher(teacherId: string) {
    return prisma.teacherSubject.findMany({
      where: { teacherId },
      include: {
        subject: true,
        class: true,
      },
    });
  }

  async delete(id: string) {
    return prisma.teacherSubject.delete({
      where: { id },
    });
  }
}

export default new TeacherSubjectService();
