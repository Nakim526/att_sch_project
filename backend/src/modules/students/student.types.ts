// src/modules/student/student.dto.ts

import { Gender } from "@prisma/client";

export interface StudentEnrollmentTypes {
  classId: string;
  semesterId: string;
}

export interface CreateStudentTypes {
  name: string;
  nis: string;
  nisn?: string;
  gender?: Gender;
  phone?: string;
  address?: string;
  classId: string;
  semesterId: string;
}

export interface UpdateStudentTypes {
  name?: string;
  nis: string;
  nisn?: string;
  gender?: Gender;
  phone?: string;
  address?: string;
  classId: string;
  semesterId: string;
}
