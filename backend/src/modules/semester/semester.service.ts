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

  async findActiveByAcademicYear(academicYearId: string) {
    return await prisma.semester.findFirst({
      where: { isActive: true, academicYearId },
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

  async update(schoolId: string, id: string, data: UpdateSemesterTypes) {
    return await prisma.$transaction(async (tx) => {
      if (data.isActive) {
        await this.ensureActive(tx, schoolId, id);
      }

      return await tx.semester.update({
        where: { id },
        data,
      });
    });
  }

  async delete(id: string) {
    return await prisma.$transaction(async (tx) => {
      const semester = await tx.semester.findUnique({
        where: { id },
        include: { academicYear: true },
      });

      if (!semester) throw new Error("Semester tidak ditemukan");

      return tx.semester.delete({
        where: { id, academicYearId: semester.academicYearId },
      });
    });
  }

  async ensureActive(
    tx: Prisma.TransactionClient,
    schoolId: string,
    id: string,
  ) {
    const semester = await tx.semester.findUnique({
      where: { id },
      include: { academicYear: true },
    });

    if (!semester) throw new Error("Semester tidak ditemukan");

    const active = await tx.semester.findFirst({
      where: {
        isActive: true,
        academicYearId: semester.academicYearId,
        id: { not: id },
      },
    });

    if (active) throw new Error(`Semester ${active.name} sedang aktif`);

    const academicYear = await tx.academicYear.findFirst({
      where: { schoolId, isActive: true, id: semester.academicYearId },
    });

    if (!academicYear)
      throw new Error(`Tahun Ajaran ${semester.academicYear.name} tidak aktif`);
  }
}

export default new SemesterService();
