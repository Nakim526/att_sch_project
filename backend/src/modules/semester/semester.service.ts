// src/modules/academic-year/academic-year.service.ts

import { SemesterType } from "@prisma/client";
import prisma from "../../config/prisma";
import { CreateSemesterTypes, UpdateSemesterTypes } from "./semester.types";

class SemesterService {
  async create(data: CreateSemesterTypes) {
    return await prisma.semester.create({
      data: {
        academicYearId: data.academicYearId,
        name: data.name,
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

  async findAllByAcademicYear(academicYearId: string) {
    return await prisma.semester.findMany({
      where: { academicYearId },
      orderBy: { startDate: "asc" },
      include: { academicYear: true },
    });
  }

  async findAllByType(name: SemesterType) {
    return await prisma.semester.findMany({
      where: { name },
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
    return await prisma.$transaction(async (tx) => {
      const existed = await tx.semester.findMany({
        where: { isActive: true },
        include: { academicYear: true },
      });

      if (existed.length > 0) {
        const semester = existed.some((s) => s.id === id);

        if (!semester) {
          throw new Error(
            `Semester ${existed
              .map((s) => {
                return `${s.name} ${s.academicYear.name}`;
              })
              .join(", ")} sedang aktif`,
          );
        }
      }

      return await tx.semester.update({
        where: { id },
        data,
      });
    });
  }

  async delete(id: string) {
    return await prisma.semester.delete({
      where: { id },
    });
  }
}

export default new SemesterService();
