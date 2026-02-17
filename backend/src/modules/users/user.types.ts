import { RoleName } from "@prisma/client";

export interface CreateUserTypes {
  schoolId: string;
  name: string;
  email: string;
  userId?: string;
  roles: RoleName[];
}
