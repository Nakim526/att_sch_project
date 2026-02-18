// src/modules/subject/subject.dto.ts

export interface CreateAcademicYearTypes {
  name: string; 
  startDate: Date;
  endDate: Date;
}

export interface UpdateAcademicYearTypes {
  name: string;
  startDate: Date;
  endDate: Date;
}
