// src/modules/class/class.dto.ts

import { ClassTeacherRole } from "@prisma/client";

export interface CheckClassTypes {
  name: string;
  gradeLevel: number;
  academicYearId: string;
  schoolId: string;
}

export interface CreateClassTypes {
  name: string; // contoh: "VII A"
  gradeLevel: number; // contoh: 7
  academicYearId: string;
  teacherId?: string;
  role?: ClassTeacherRole;
}

export interface UpdateClassTypes {
  name: string;
  gradeLevel: number;
  teacherId?: string;
  role?: ClassTeacherRole;
  academicYearId: string;
}

export interface ClassTeacherAssignmentTypes {
  classId: string;
  teacherId: string;
  role?: ClassTeacherRole;
}
