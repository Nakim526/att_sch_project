// src/modules/academic-year/academic-year.service.ts

import { SemesterType } from "@prisma/client";
import prisma from "../../config/prisma";
import { CreateSemesterTypes, UpdateSemesterTypes } from "./semester.types";

class SemesterService {
  async create(data: CreateSemesterTypes) {
    return await prisma.semester.create({
      data: {
        academicYearId: data.academicYearId,
        name: data.type,
        startDate: data.startDate,
        endDate: data.endDate,
      },
    });
  }

  async findAllBySchool() {
    return await prisma.semester.findMany({
      orderBy: { startDate: "asc" },
      include: { academicYear: true },
    });
  }

  async findAllByType(type: SemesterType) {
    return await prisma.semester.findMany({
      where: { name: type },
      orderBy: { startDate: "asc" },
      include: { academicYear: true },
    });
  }

  async findById(id: string) {
    return await prisma.semester.findUnique({
      where: { id },
      include: { academicYear: true },
    });
  }

  async update(id: string, data: UpdateSemesterTypes) {
    return await prisma.semester.update({
      where: { id },
      data,
    });
  }

  async delete(id: string) {
    return await prisma.semester.delete({
      where: { id },
    });
  }
}

export default new SemesterService();
