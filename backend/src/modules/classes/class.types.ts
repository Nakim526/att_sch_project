// src/modules/class/class.dto.ts

export interface CreateClassTypes {
  name: string; // contoh: "VII A"
  grade: number; // contoh: 7
}

export interface UpdateClassTypes {
  name?: string;
  grade?: number;
}
