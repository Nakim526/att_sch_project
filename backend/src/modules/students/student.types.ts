// src/modules/student/student.dto.ts

export interface CreateStudentTypes {
  fullName: string;
  nis: string;
  classId: string;
}

export interface UpdateStudentTypes {
  fullName?: string;
  nis?: string;
  classId?: string;
}
