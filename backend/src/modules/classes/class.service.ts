// src/modules/class/class.service.ts

import prisma from "../../config/prisma";
import { CreateClassTypes, UpdateClassTypes } from "./class.types";

class ClassService {
  async create(schoolId: string, data: CreateClassTypes) {
    return prisma.class.create({
      data: {
        schoolId,
        name: data.name,
        gradeLevel: data.grade,
        academicYearId: data.academicYearId,
      },
    });
  }

  async findAllBySchool(schoolId: string) {
    return prisma.class.findMany({
      where: { schoolId },
      orderBy: [{ gradeLevel: "asc" }, { name: "asc" }],
    });
  }

  async findById(id: string) {
    return prisma.class.findUnique({
      where: { id },
    });
  }

  async update(id: string, data: UpdateClassTypes) {
    return prisma.class.update({
      where: { id },
      data,
    });
  }

  async delete(id: string) {
    return prisma.class.delete({
      where: { id },
    });
  }
}

export default new ClassService();
