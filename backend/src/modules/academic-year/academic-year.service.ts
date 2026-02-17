// src/modules/academic-year/academic-year.service.ts

import prisma from "../../config/prisma";
import { CreateAcademicYearTypes, UpdateAcademicYearTypes } from "./academic-year.types";

class AcademicYearService {
  async create(schoolId: string, data: CreateAcademicYearTypes) {
    return prisma.academicYear.create({
      data: {
        schoolId,
        name: data.name,
        startDate: data.startDate,
        endDate: data.endDate,
      },
    });
  }

  async findAllBySchool(schoolId: string) {
    return prisma.academicYear.findMany({
      where: { schoolId },
      orderBy: { name: "asc" },
    });
  }

  async findById(id: string) {
    return prisma.academicYear.findUnique({
      where: { id },
    });
  }

  async update(id: string, data: UpdateAcademicYearTypes) {
    return prisma.academicYear.update({
      where: { id },
      data,
    });
  }

  async delete(id: string) {
    return prisma.academicYear.delete({
      where: { id },
    });
  }
}

export default new AcademicYearService();
