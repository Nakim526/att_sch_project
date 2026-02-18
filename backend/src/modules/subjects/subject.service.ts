// src/modules/subject/subject.service.ts

import prisma from "../../config/prisma";
import { CreateSubjectTypes, UpdateSubjectTypes } from "./subject.types";

class SubjectService {
  async create(schoolId: string, data: CreateSubjectTypes) {
    return await prisma.subject.create({
      data: {
        schoolId,
        name: data.name,
        code: data.code,
      },
    });
  }

  async findAllBySchool(schoolId: string) {
    return await prisma.subject.findMany({
      where: { schoolId },
      orderBy: { name: "asc" },
    });
  }

  async findById(id: string) {
    return await prisma.subject.findUnique({
      where: { id },
    });
  }

  async update(id: string, data: UpdateSubjectTypes) {
    return await prisma.subject.update({
      where: { id },
      data,
    });
  }

  async delete(id: string) {
    return await prisma.subject.delete({
      where: { id },
    });
  }
}

export default new SubjectService();
