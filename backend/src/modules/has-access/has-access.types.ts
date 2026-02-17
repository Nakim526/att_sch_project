import { RoleName } from "@prisma/client";

export interface CreateHasAccessTypes {
  schoolId: string;
  name: string;
  email: string;
  roles: RoleName[];
}

export interface UpdateHasAccessTypes {
  name?: string;
  email?: string;
  roles?: RoleName[];
}