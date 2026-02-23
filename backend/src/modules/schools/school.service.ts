import { Prisma, RoleName } from "@prisma/client";
import prisma from "../../config/prisma";
import userService from "../users/user.service";
import {
  AdminTypes,
  CreateSchoolTypes,
  UpdatePrincipalTypes,
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

    if (!principal)
      throw new Error("Kepala Sekolah tidak ditemukan, Silahkan hubungi Admin");

    return principal;
  }

  async updatePrincipal(
    tx: Prisma.TransactionClient,
    data: UpdatePrincipalTypes,
  ) {
    // ambil id role baru
    const roles = await tx.role.findMany({
      where: { name: { in: data.newRoles } },
    });

    const principalRole = roles.find((r) => r.name === RoleName.KEPSEK);

    // hapus role kepsek sebelumnya
    await tx.userRole.delete({
      where: {
        userId_roleId: { userId: data.oldId, roleId: principalRole!.id },
      },
    });

    // hapus semua role lama
    await tx.userRole.deleteMany({
      where: { userId: data.newId },
    });

    // assign role baru
    await tx.userRole.createMany({
      data: roles.map((r) => ({
        userId: data.newId,
        roleId: r.id,
      })),
    });

    return await tx.user.update({
      where: { id: data.newId },
      data: { name: data.newName },
    });
  }

  async createSchool(data: CreateSchoolTypes) {
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
        include: { roles: { include: { role: true } } },
      });

      if (!oldPrincipal) throw new Error("Kepala Sekolah tidak ditemukan");

      const newPrincipal = await tx.allowedEmail.findUnique({
        where: { schoolId_email: { schoolId: id, email: data.principalEmail } },
        include: {
          user: { include: { roles: { select: { role: true } } } },
        },
      });

      if (!newPrincipal) throw new Error("User tidak ditemukan");

      let principal = null;

      if (oldPrincipal.email !== newPrincipal.email) {
        const oldPrincipalRoles = oldPrincipal.roles.map((r) => r.role.name);

        if (oldPrincipalRoles.length === 1)
          throw new Error(
            `Tidak bisa dihapus, setidaknya ${oldPrincipal.name} memiliki 2 hak akses`,
          );

        const newPrincipalRoles = newPrincipal.user.roles.map(
          (r) => r.role.name,
        );

        principal = await this.updatePrincipal(tx, {
          oldId: oldPrincipal.id,
          newId: newPrincipal.user.id,
          newName: data.principalName,
          newRoles: [...newPrincipalRoles, RoleName.KEPSEK],
        });
      } else {
        principal = await tx.user.update({
          where: { id: oldPrincipal.id },
          data: { name: data.principalName },
        });
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

      return { school, principal };
    });
  }

  async deleteSchool(id: string) {
    return await prisma.$transaction(async (tx) => {
      await tx.teachingAssignment.deleteMany({
        where: { teacher: { schoolId: id } },
      });

      return await tx.school.delete({ where: { id } });
    });
  }
}

export default new SchoolService();
