import { RoleName } from "@prisma/client";

export interface AdminTypes {
  id: string;
  email: string;
}

export interface UpdatePrincipalTypes {
  oldId: string;
  newId: string;
  newName: string;
  newRoles: RoleName[];
}

export interface CreateSchoolTypes {
  principalName: string;
  principalEmail: string;
  name: string;
  address: string;
  phone?: string;
  email?: string;
}

export interface UpdateSchoolTypes {
  principalName: string;
  principalEmail: string;
  name: string;
  address: string;
  phone?: string;
  email?: string;
}
