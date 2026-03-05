// src/modules/attendance/teacher-attendance.dto.ts

import { TeacherAttendanceStatus } from "@prisma/client";

export interface TeacherCheckInTypes {
  teacherId: string;
  schoolId: string;
  photo: Express.Multer.File;
  latitude: number;
  longitude: number;
  status: TeacherAttendanceStatus;
  note?: string;
  isLate?: boolean;
}
