import prisma from "../../config/prisma";
import { AuthRequest } from "../../middlewares/auth.middleware";
import { CreateSchoolTypes } from "./school.types";

export async function createSchool(data: CreateSchoolTypes) {
  return prisma.school.create({ data });
}

export async function getAllSchools(schoolId: string) {
  return prisma.school.findMany({ where: { id: schoolId } });
}

export async function getMySchool(id: string) {
  return prisma.school.findUnique({
    where: { id },
  });
}
