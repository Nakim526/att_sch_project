// src/modules/subject/subject.dto.ts

import { SemesterType } from "@prisma/client";

export interface CreateSemesterTypes {
  academicYearId: string;
  type: SemesterType;
  startDate: Date;
  endDate: Date;
}

export interface UpdateSemesterTypes {
  academicYearId: string;
  type: SemesterType;
  startDate: Date;
  endDate: Date;
  isActive?: boolean;
}
