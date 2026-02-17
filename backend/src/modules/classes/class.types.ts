// src/modules/class/class.dto.ts

export interface CreateClassTypes {
  name: string; // contoh: "VII A"
  grade: number; // contoh: 7
  academicYearId: string;
}

export interface UpdateClassTypes {
  name?: string;
  grade?: number;
}
