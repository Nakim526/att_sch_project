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
    });
  }

  async findById(id: string) {
    return await prisma.academicYear.findUnique({
      where: { id },
    });
  }

  async update(schoolId: string, id: string, data: UpdateAcademicYearTypes) {
    return await prisma.$transaction(async (tx) => {
      if (data.isActive) {
        await this.ensureActive(tx, schoolId, id);

        await tx.class.updateMany({
          where: { schoolId },
          data: { academicYearId: id },
        });
      } else {
        await this.ensureNotActive(tx, id);
      }

      return await tx.academicYear.update({
        where: { id },
        data,
      });
    });
  }

  async delete(schoolId: string, id: string) {
    return await prisma.academicYear.delete({
      where: { schoolId, id },
    });
  }

  async ensureNotActive(tx: Prisma.TransactionClient, id: string) {
    const active = await tx.semester.findFirst({
      where: { isActive: true, academicYearId: id },
    });

    if (active) {
      throw new Error(
        `Semester ${active.name} sedang aktif, silahkan non-aktifkan terlebih dahulu`,
      );
    }
  }

  async ensureActive(
    tx: Prisma.TransactionClient,
    schoolId: string,
    id: string,
  ) {
    const active = await tx.academicYear.findFirst({
      where: { schoolId, isActive: true, id: { not: id } },
    });

    if (active) throw new Error(`Tahun Ajaran ${active.name} sedang aktif`);
  }
}

export default new AcademicYearService();
