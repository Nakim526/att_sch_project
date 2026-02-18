// src/modules/subject/subject.dto.ts

export interface CreateSubjectTypes {
  name: string; // contoh: "Matematika"
  code?: string;
}

export interface UpdateSubjectTypes {
  name?: string;
  code?: string;
}
