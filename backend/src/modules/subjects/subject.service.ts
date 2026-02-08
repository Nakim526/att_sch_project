// src/modules/subject/subject.service.ts

import prisma from "../../config/prisma";
import { CreateSubjectTypes, UpdateSubjectTypes } from "./subject.types";

class SubjectService {
  async create(schoolId: string, data: CreateSubjectTypes) {
    return prisma.subject.create({
      data: {
        schoolId,
        name: data.name,
      },
    });
  }

  async findAllBySchool(schoolId: string) {
    return prisma.subject.findMany({
      where: { schoolId },
      orderBy: { name: "asc" },
    });
  }

  async findById(id: string) {
    return prisma.subject.findUnique({
      where: { id },
    });
  }

  async update(id: string, data: UpdateSubjectTypes) {
    return prisma.subject.update({
      where: { id },
      data,
    });
  }

  async delete(id: string) {
    return prisma.subject.delete({
      where: { id },
    });
  }
}

export default new SubjectService();
