import prisma from "../../config/prisma";
import {
  CreateTeacherTypes,
  TeachingAssignmentTypes,
  UpdateTeacherTypes,
} from "./teacher.types";
import userService from "../users/user.service";
import { Prisma, RoleName } from "@prisma/client";

class TeacherService {
  async ensureAvailable(
    tx: Prisma.TransactionClient,
    nip: string,
    email: string,
    id?: string,
  ) {
    const user = await tx.user.findUnique({
      where: { email },
    });

    if (!user) {
      throw new Error(`Email ${email} tidak ditemukan`);
    }

    const emailUsed = await tx.teacher.findFirst({
      where: {
        userId: user!.id,
        ...(id && { id: { not: id } }),
      },
    });

    if (emailUsed) {
      throw new Error(`Email ${email} sudah digunakan`);
    }

    const nipUsed = await tx.teacher.findFirst({
      where: {
        nip,
        ...(id && { id: { not: id } }),
      },
    });

    if (nipUsed) {
      throw new Error(`NIP atau email sudah digunakan`);
    }

    return user;
  }

  async assignRole(tx: Prisma.TransactionClient, userId: string) {
    const role = await tx.role.findFirst({
      where: { name: RoleName.GURU },
    });

    return await tx.userRole.upsert({
      where: { userId_roleId: { userId, roleId: role!.id } },
      update: { userId, roleId: role!.id },
      create: { userId, roleId: role!.id },
    });
  }

  async assignTeacher(
    tx: Prisma.TransactionClient,
    teacherId: string,
    data: TeachingAssignmentTypes[],
  ) {
    await tx.teachingAssignment.deleteMany({
      where: { teacherId, semesterId: data[0].semesterId },
    });

    for (const assignment of data) {
      await tx.teachingAssignment.upsert({
        where: {
          teacherId_subjectId_classId_semesterId: {
            teacherId,
            subjectId: assignment.subjectId,
            classId: assignment.classId,
            semesterId: assignment.semesterId,
          },
        },
        update: {},
        create: {
          teacher: { connect: { id: teacherId } },
          subject: { connect: { id: assignment.subjectId } },
          class: { connect: { id: assignment.classId } },
          semester: { connect: { id: assignment.semesterId } },
        },
      });
    }
  }

  async createTeacher(schoolId: string, data: CreateTeacherTypes) {
    return await prisma.$transaction(async (tx) => {
      const user = await this.ensureAvailable(tx, data.nip, data.email);

      await this.assignRole(tx, user.id);

      const teacher = await tx.teacher.create({
        data: {
          schoolId,
          userId: user.id,
          nip: data.nip,
          name: data.name,
          gender: data.gender,
          phone: data.phone,
          address: data.address,
        },
      });

      await this.assignTeacher(tx, teacher.id, data.assignments);

      return teacher;
    });
  }

  async readTeachersList(schoolId: string) {
    return await prisma.teacher.findMany({
      where: { schoolId },
      include: {
        user: true,
        teachingAssignments: true,
        classAssignments: true,
      },
    });
  }

  async readTeacherDetail(id: string) {
    return await prisma.teacher.findUnique({
      where: { id },
      include: {
        user: true,
        teachingAssignments: true,
        classAssignments: true,
      },
    });
  }

  async readMySelf(userId: string) {
    return await prisma.teacher.findUnique({
      where: { userId },
      include: {
        user: true,
        teachingAssignments: true,
        classAssignments: true,
        vaultFiles: true,
      },
    });
  }

  async updateTransaction(
    tx: Prisma.TransactionClient,
    id: string,
    data: UpdateTeacherTypes,
  ) {
    const user = await this.ensureAvailable(tx, data.nip, data.email, id);

    await this.assignRole(tx, user.id);

    const teacher = await tx.teacher.update({
      where: { id },
      data: {
        userId: user.id,
        nip: data.nip,
        name: data.name,
        gender: data.gender,
        phone: data.phone,
        address: data.address,
      },
    });

    await this.assignTeacher(tx, teacher.id, data.assignments);

    return teacher;
  }

  async updateTeacher(id: string, data: UpdateTeacherTypes) {
    return await prisma.$transaction(async (tx) => {
      return await this.updateTransaction(tx, id, data);
    });
  }

  async updateMySelf(userId: string, data: UpdateTeacherTypes) {
    return await prisma.$transaction(async (tx) => {
      const teacher = await tx.teacher.findUnique({ where: { userId } });

      if (!teacher) throw new Error("Guru tidak ditemukan");

      return await this.updateTransaction(tx, teacher!.id, data);
    });
  }

  async deleteTeacher(id: string, schoolId: string) {
    return await prisma.$transaction(async (tx) => {
      await tx.teachingAssignment.deleteMany({ where: { teacherId: id } });

      return await tx.teacher.delete({ where: { id, schoolId } });
    });
  }
}

export default new TeacherService();
