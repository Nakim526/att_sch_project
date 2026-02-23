// src/modules/class/class.dto.ts

import { ClassTeacherRole } from "@prisma/client";

export interface CreateClassTypes {
  name: string; // contoh: "VII A"
  gradeLevel: number; // contoh: 7
  academicYearId: string;
  teacherId?: string;
  role?: ClassTeacherRole;
}

export interface UpdateClassTypes {
  name?: string;
  gradeLevel?: number;
  teacherId?: string;
  role?: ClassTeacherRole;
}

export interface ClassTeacherAssignmentTypes {
  classId: string;
  teacherId: string;
  role?: ClassTeacherRole;
}
