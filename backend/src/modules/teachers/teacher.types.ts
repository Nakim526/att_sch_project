import { Gender } from "@prisma/client";

export interface CreateTeacherTypes {
  nip: string;
  name: string;
  email: string;
  gender?: Gender;
  phone?: string;
  address?: string;
  subjectId: string;
  classId: string;
  semesterId: string;
}

export interface CreateTeachingAssignmentTypes {
  subjectId: string;
  classId: string;
  semesterId: string;
}

export interface UpdateTeacherTypes {
  nip: string;
  name: string;
  email: string;
  gender?: Gender;
  phone?: string;
  address?: string;
  subjectId: string;
  classId: string;
  semesterId: string;
}
