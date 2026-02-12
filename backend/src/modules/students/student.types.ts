// src/modules/student/student.dto.ts

export interface CreateStudentTypes {
  name: string;
  nis: string;
  classId: string;
}

export interface UpdateStudentTypes {
  name?: string;
  nis?: string;
  classId?: string;
}
