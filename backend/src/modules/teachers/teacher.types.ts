export interface CreateTeacherTypes {
  name: string;
  nip: string;
  email: string;
  roles?: string[];
  userId: string;
  schoolId: string;
}

export interface UpdateTeacherTypes {
  id: string;
  name: string;
  nip: string;
  email: string;
  roles?: string[];
  userId: string;
  schoolId: string;
}