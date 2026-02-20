import { RoleName } from "@prisma/client";

export interface CreateUserTypes {
  name: string;
  email: string;
  roles: RoleName[];
  avatar?: string;
}

export interface UpdateUserTypes {
  name: string;
  email: string;
  roles: RoleName[];
  avatar?: string;
  isActive?: boolean;
}
