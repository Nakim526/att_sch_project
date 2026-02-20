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
      if (data.isActive) {
        const self = await this.anyActive(tx, id);

        const active = await tx.semester.findMany({
          where: { isActive: true },
        });

        let selfChild = true;

        if (active.length > 0) {
          selfChild = active.some((s) => s.academicYearId === id);

          if (!selfChild) {
            throw new Error(
              `Semester ${active
                .map((s) => s.name)
                .join(
                  ", ",
                )} sedang aktif, silahkan non-aktifkan terlebih dahulu`,
            );
          }
        }

        if (!self && !selfChild) {
          throw new Error("Unknown Error, contact admin to fix it");
        }

        await tx.class.updateMany({
          data: { academicYearId: id },
        });
      }

      return await tx.academicYear.update({
        where: { id },
        data,
      });
    });
  }

  async delete(id: string) {
    return await prisma.academicYear.delete({
      where: { id },
    });
  }

  async anyActive(tx: Prisma.TransactionClient, id: string) {
    const active = await tx.academicYear.findMany({
      where: { isActive: true },
    });

    let self = true;

    if (active.length > 0) {
      self = active.some((e) => e.id === id);

      if (!self) {
        throw new Error(
          `Tahun Ajaran ${active.map((e) => e.name).join(", ")} sedang aktif`,
        );
      }
    }

    return self;
  }
}

export default new AcademicYearService();
