export interface CreateHasAccessTypes {
  schoolId: string;
  name: string;
  email: string;
  roles: string[];
}

export interface UpdateHasAccessTypes {
  name?: string;
  email?: string;
  roles?: string[];
}