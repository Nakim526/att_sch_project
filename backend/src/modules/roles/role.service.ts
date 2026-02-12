import prisma from "../../config/prisma";
import { AuthRequest } from "../../middlewares/auth.middleware";
import { CreateRoleTypes } from "./role.types";

export async function getAllRoles() {
  return prisma.role.findMany();
}
