import { DayOfWeek, Gender } from "@prisma/client";

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
  classId: string;
  subjectId: string;
  semesterId: string;
  schedules: ClassScheduleTypes[];
}

export interface ClassScheduleTypes {
  dayOfWeek: DayOfWeek;
  startTime: string;
  endTime: string;
  room?: string;
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
