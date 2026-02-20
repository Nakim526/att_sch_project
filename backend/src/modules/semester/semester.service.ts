// src/modules/academic-year/academic-year.service.ts

import { Prisma, SemesterType } from "@prisma/client";
import prisma from "../../config/prisma";
import { CreateSemesterTypes, UpdateSemesterTypes } from "./semester.types";
import academicYearService from "../academic-year/academic-year.service";

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
      if (data.isActive) {
        const self = await this.anyActive(tx, id);

        const selfParent = await academicYearService.anyActive(
          tx,
          data.academicYearId,
        );

        if (!self && !selfParent) {
          throw new Error("Unknown Error, contact admin to fix it");
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

  async anyActive(tx: Prisma.TransactionClient, id: string) {
    const active = await tx.semester.findMany({
      where: { isActive: true },
      include: { academicYear: true },
    });

    let self = true;

    if (active.length > 0) {
      self = active.some((s) => s.id === id);

      if (!self) {
        throw new Error(
          `Semester ${active
            .map((s) => {
              return `${s.name} ${s.academicYear.name}`;
            })
            .join(", ")} sedang aktif`,
        );
      }
    }

    return self;
  }
}

export default new SemesterService();
