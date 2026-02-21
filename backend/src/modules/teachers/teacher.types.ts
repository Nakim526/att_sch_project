import { Gender } from "@prisma/client";

export interface CreateTeacherTypes {
  nip: string;
  name: string;
  email: string;
  gender?: Gender;
  phone?: string;
  address?: string;
  assignments: TeachingAssignmentTypes[];
}

export interface TeachingAssignmentTypes {
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
  assignments: TeachingAssignmentTypes[];
}
