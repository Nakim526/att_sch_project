// src/modules/academic-year/academic-year.service.ts

import { Prisma } from "@prisma/client";
import prisma from "../../config/prisma";
import {
  CreateAcademicYearTypes,
  UpdateAcademicYearTypes,
} from "./academic-year.types";

class AcademicYearService {
  async create(schoolId: string, data: CreateAcademicYearTypes) {
    return await prisma.academicYear.create({
      data: {
        schoolId,
        name: data.name,
        startDate: data.startDate,
        endDate: data.endDate,
      },
    });
  }

  async findAllBySchool(schoolId: string) {
    return await prisma.academicYear.findMany({
      where: { schoolId },
      orderBy: { name: "asc" },
    });
  }

  async findActive(schoolId: string) {
    return await prisma.academicYear.findFirst({
      where: { isActive: true, schoolId },
      orderBy: { name: "asc" },
    });
  }

  async findById(id: string) {
    return await prisma.academicYear.findUnique({
      where: { id },
    });
  }

  async update(id: string, data: UpdateAcademicYearTypes) {
    return await prisma.$transaction(async (tx) => {
      const self = await this.anyActive(tx, id);

      const semesters = await tx.semester.findMany({
        where: { academicYearId: id, isActive: true },
      });

      if (semesters.length > 0) {
        throw new Error(
          `Semester ${semesters.map((s) => s.name).join(", ")} sedang aktif`,
        );
      }

      if (self && semesters.length === 0) {
        await tx.class.updateMany({
          data: { academicYearId: id },
        });

        return await tx.academicYear.update({
          where: { id },
          data,
        });
      }

      throw new Error('Unknown Error, contact admin to fix it');
    });
  }

  async delete(id: string) {
    return await prisma.academicYear.delete({
      where: { id },
    });
  }

  async anyActive(tx: Prisma.TransactionClient, id: string) {
    const existed = await tx.academicYear.findMany({
      where: { isActive: true },
    });

    let self = null;

    if (existed.length > 0) {
      self = existed.some((s) => s.id === id);

      if (!self) {
        throw new Error(
          `Tahun Ajaran ${existed.map((s) => s.name).join(", ")} sedang aktif`,
        );
      }
    }

    return self;
  }
}

export default new AcademicYearService();
