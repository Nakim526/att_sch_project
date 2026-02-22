import { Prisma, RoleName } from "@prisma/client";
import prisma from "../../config/prisma";
import userService from "../users/user.service";
import {
  AdminTypes,
  CreateSchoolTypes,
  UpdateSchoolTypes,
} from "./school.types";

class SchoolService {
  async ensureAvailable(
    tx: Prisma.TransactionClient,
    name: string,
    id?: string,
  ) {
    const used = await tx.school.findFirst({
      where: { name, ...(id && { id: { not: id } }) },
    });

    if (used) throw new Error(`Sekolah ${name} sudah digunakan`);
  }

  async getPrincipal(tx: Prisma.TransactionClient, schoolId: string) {
    const principal = await tx.user.findFirst({
      where: {
        schoolId,
        roles: { some: { role: { name: RoleName.KEPSEK } } },
      },
    });

    if (!principal) throw new Error("Kepala Sekolah tidak ditemukan");

    return principal;
  }

  async updatePrincipal(
    tx: Prisma.TransactionClient,
    oldPrincipalId: string,
    newPrincipalId: string,
    newPrincipalRoles: RoleName[],
  ) {
    const role = await tx.role.findFirst({
      where: { name: RoleName.KEPSEK },
    });

    await tx.userRole.delete({
      where: {
        userId_roleId: { userId: oldPrincipalId, roleId: role!.id },
      },
    });

    await tx.userRole.createMany({
      data: newPrincipalRoles.map((r) => ({
        userId: newPrincipalId,
        roleId: r,
      })),
    });
  }

  async createSchool(admin: AdminTypes, data: CreateSchoolTypes) {
    return prisma.$transaction(async (tx) => {
      console.log(`DATA: ${JSON.stringify(data)}`);
      await this.ensureAvailable(tx, data.name);

      const school = await tx.school.create({
        data: {
          name: data.name,
          address: data.address,
          phone: data.phone,
          email: data.email,
        },
      });

      const user = await tx.user.findUnique({
        where: { email: data.principalEmail },
      });

      if (user) throw new Error("Email sudah digunakan");

      const principal = await userService.createUserTransaction(tx, school.id, {
        name: data.principalName,
        email: data.principalEmail,
        roles: [RoleName.KEPSEK],
      });

      await tx.allowedEmail.create({
        data: { schoolId: school.id, userId: admin.id, email: admin.email },
      });

      return { school, principal };
    });
  }

  async getAllSchools() {
    return await prisma.school.findMany();
  }

  async getMySchool(id: string) {
    return await prisma.$transaction(async (tx) => {
      const school = await tx.school.findUnique({
        where: { id },
      });

      if (!school) throw new Error("Sekolah tidak ditemukan");

      const principal = await this.getPrincipal(tx, id);

      return { school, principal };
    });
  }

  async getSchoolById(id: string) {
    return await prisma.$transaction(async (tx) => {
      const school = await tx.school.findUnique({
        where: { id },
      });

      if (!school) throw new Error("Sekolah tidak ditemukan");

      const principal = await this.getPrincipal(tx, id);

      return { school, principal };
    });
  }

  async updateSchool(id: string, data: UpdateSchoolTypes) {
    return await prisma.$transaction(async (tx) => {
      await this.ensureAvailable(tx, data.name, id);

      const school = await tx.school.findUnique({ where: { id } });

      if (!school) throw new Error("Sekolah tidak ditemukan");

      const oldPrincipal = await tx.user.findFirst({
        where: {
          schoolId: id,
          roles: { some: { role: { name: RoleName.KEPSEK } } },
        },
      });

      if (!oldPrincipal) throw new Error("Kepala Sekolah tidak ditemukan");

      const newPrincipal = await tx.allowedEmail.findUnique({
        where: { schoolId_email: { schoolId: id, email: data.principalEmail } },
        include: { user: { select: { roles: { select: { role: true } } } } },
      });

      if (!newPrincipal) throw new Error("User tidak ditemukan");

      if (oldPrincipal.email !== newPrincipal.email) {
        const rolesNewPrincipal = newPrincipal.user.roles.map(
          (r) => r.role.name,
        );

        await this.updatePrincipal(tx, oldPrincipal.id, newPrincipal.id, [
          ...rolesNewPrincipal,
          RoleName.KEPSEK,
        ]);
      }

      await tx.school.update({
        where: { id },
        data: {
          name: data.name,
          address: data.address,
          phone: data.phone,
          email: data.email,
        },
      });

      const principal = await this.getPrincipal(tx, id);

      return { school, principal };
    });
  }

  async deleteSchool(id: string) {
    return await prisma.school.delete({ where: { id } });
  }
}

export default new SchoolService();
