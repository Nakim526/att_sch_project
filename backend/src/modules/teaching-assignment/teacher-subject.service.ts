// src/modules/teacher-subject/teacher-subject.service.ts

import prisma from "../../config/prisma";
import { CreateTeacherSubjectTypes } from "./teacher-subject.types";

class TeacherSubjectService {
  async assign(data: CreateTeacherSubjectTypes) {
    return prisma.teachingAssignment.create({
      data: {
        teacherId: data.teacherId,
        subjectId: data.subjectId,
        classId: data.classId,
        semesterId: data.semesterId,
      },
    });
  }

  async findAllBySchool(schoolId: string) {
    return prisma.teachingAssignment.findMany({
      where: {
        class: {
          schoolId,
        },
      },
      include: {
        teacher: {
          select: { id: true, name: true, user: { select: { email: true } } },
        },
        subject: true,
        class: true,
        semester: true,
      },
    });
  }

  async findByTeacher(teacherId: string) {
    return prisma.teachingAssignment.findMany({
      where: { teacherId },
      include: {
        teacher: true,
        subject: true,
        class: true,
        schedules: true,
        attendances: true,
      },
    });
  }

  async delete(id: string) {
    return prisma.teachingAssignment.delete({
      where: { id },
    });
  }
}

export default new TeacherSubjectService();
