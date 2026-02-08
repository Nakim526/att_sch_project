// src/modules/attendance/teacher-attendance.dto.ts

export interface TeacherCheckInTypes {
  teacherId: string;
  schoolId: string;
  photo: Express.Multer.File;
  latitude: number;
  longitude: number;
}
