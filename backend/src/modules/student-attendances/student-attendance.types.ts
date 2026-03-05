// src/modules/attendance/student-attendance.dto.ts

import { AttendanceStatus } from '@prisma/client';

export interface StudentAttendanceItemTypes {
  studentId: string;
  teachingAssignmentId: string;
  scheduleId?: string;
  createdById: string;
  status: AttendanceStatus;
  note?: string;
}

export interface CreateStudentAttendanceTypes {
  classId: string;
  subjectId: string;
  attendanceDate: string; // ISO date: "2026-02-09"
  attendances: StudentAttendanceItemTypes[];
}
