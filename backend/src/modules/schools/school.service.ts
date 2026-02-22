import { Prisma, RoleName } from "@prisma/client";
import prisma from "../../config/prisma";
import { AuthRequest } from "../../middlewares/auth.middleware";
import userService from "../users/user.service";
import { CreateSchoolTypes, UpdateSchoolTypes } from "./school.types";

class SchoolService {
  async ensureAvailable(tx: Prisma.TransactionClient, name: string) {
    const used = await tx.school.findFirst({ where: { name } });

    if (used) throw new Error(`Sekolah ${name} sudah digunakan`);
  }

  async createSchool(data: CreateSchoolTypes) {
    return prisma.$transaction(async (tx) => {
      await this.ensureAvailable(tx, data.name);

      const school = await tx.school.create({
        data: { name: data.name, address: data.address },
      });

      await userService.createUserTransaction(tx, school.id, {
        name: data.userName,
        email: data.userEmail,
        roles: [RoleName.ADMIN],
      });

      return school;
    });
  }

  async getAllSchools() {
    return await prisma.school.findMany();
  }

  async getMySchool(id: string) {
    return await prisma.school.findUnique({
      where: { id },
    });
  }

  async getSchoolById(id: string) {
    return await prisma.school.findUnique({
      where: { id },
    });
  }

  async updateSchool(id: string, data: UpdateSchoolTypes) {
    return await prisma.$transaction(async (tx) => {
      await this.ensureAvailable(tx, data.name);

      return await tx.school.update({
        where: { id },
        data,
      });
    });
  }

  async deleteSchool(id: string) {
    return await prisma.school.delete({ where: { id } });
  }
}

export default new SchoolService();
