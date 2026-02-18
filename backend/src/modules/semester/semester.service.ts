// src/modules/academic-year/academic-year.service.ts

import { SemesterType } from "@prisma/client";
import prisma from "../../config/prisma";
import { CreateSemesterTypes, UpdateSemesterTypes } from "./semester.types";

class SemesterService {
  async create(data: CreateSemesterTypes) {
    return prisma.semester.create({
      data: {
        academicYearId: data.academicYearId,
        type: data.type,
        startDate: data.startDate,
        endDate: data.endDate,
      },
    });
  }

  async findAllBySchool() {
    return prisma.semester.findMany({
      orderBy: { startDate: "asc" },
      include: { academicYear: true },
    });
  }

  async findAllByType(type: SemesterType) {
    return prisma.semester.findMany({
      where: { type: type },
      orderBy: { startDate: "asc" },
      include: { academicYear: true },
    });
  }

  async findById(id: string) {
    return prisma.semester.findUnique({
      where: { id },
      include: { academicYear: true },
    });
  }

  async update(id: string, data: UpdateSemesterTypes) {
    return prisma.semester.update({
      where: { id },
      data,
    });
  }

  async delete(id: string) {
    return prisma.semester.delete({
      where: { id },
    });
  }
}

export default new SemesterService();
