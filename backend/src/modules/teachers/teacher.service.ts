import prisma from "../../config/prisma";
import {
  CreateTeacherTypes,
  CreateTeachingAssignmentTypes,
  UpdateTeacherTypes,
} from "./teacher.types";
import userService from "../users/user.service";
import { Prisma, RoleName } from "@prisma/client";

class TeacherService {
  async anyUsed(tx: Prisma.TransactionClient, nip: string) {
    const teachers = await tx.teacher.findMany({
      where: { nip },
    });

    let self = true;

    if (teachers.length > 0) {
      self = teachers.some((t) => t.nip === nip);
    }

    if (!self) {
      throw new Error(`NIP ${nip} sudah digunakan`);
    }

    return self;
  }

  async assignRole(tx: Prisma.TransactionClient, userId: string) {
    const role = await tx.role.findUnique({
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
    data: CreateTeachingAssignmentTypes,
  ) {
    return await tx.teachingAssignment.upsert({
      where: {
        teacherId_subjectId_classId_semesterId: {
          teacherId,
          subjectId: data.subjectId,
          classId: data.classId,
          semesterId: data.semesterId,
        },
      },
      update: {},
      create: {
        teacherId,
        subjectId: data.subjectId,
        classId: data.classId,
        semesterId: data.semesterId,
      },
    });
  }

  async createTeacher(schoolId: string, data: CreateTeacherTypes) {
    return await prisma.$transaction(async (tx) => {
      await userService.anyUsed(tx, data.email);

      await this.anyUsed(tx, data.nip);

      await this.assignRole(tx, data.userId);

      const teacher = await tx.teacher.create({
        data: {
          schoolId,
          userId: data.userId,
          nip: data.nip,
          name: data.name,
          gender: data.gender,
          phone: data.phone,
          address: data.address,
        },
      });

      await this.assignTeacher(tx, teacher.id, {
        subjectId: data.subjectId,
        classId: data.classId,
        semesterId: data.semesterId,
      });

      return teacher;
    });
  }

  async readTeachersList(schoolId: string) {
    return await prisma.teacher.findMany({ where: { schoolId } });
  }

  async readTeacherDetail(id: string) {
    return await prisma.teacher.findUnique({ where: { id } });
  }

  async readMySelf(userId: string) {
    return await prisma.teacher.findUnique({ where: { userId } });
  }

  async updateTransaction(
    tx: Prisma.TransactionClient,
    id: string,
    data: UpdateTeacherTypes,
  ) {
    await userService.anyUsed(tx, data.email);

    await this.anyUsed(tx, data.nip);

    await this.assignRole(tx, data.userId);

    const teacher = await tx.teacher.update({
      where: { id },
      data: {
        userId: data.userId,
        nip: data.nip,
        name: data.name,
        gender: data.gender,
        phone: data.phone,
        address: data.address,
      },
    });

    await this.assignTeacher(tx, teacher.id, {
      subjectId: data.subjectId,
      classId: data.classId,
      semesterId: data.semesterId,
    });

    return teacher;
  }

  async updateTeacher(id: string, data: UpdateTeacherTypes) {
    return await prisma.$transaction(async (tx) => {
      return await this.updateTransaction(tx, id, data);
    });
  }

  async updateMySelf(userId: string, data: UpdateTeacherTypes) {
    return await prisma.$transaction(async (tx) => {
      const teacher = await this.readMySelf(userId);

      if (!teacher) throw new Error("Guru tidak ditemukan");

      return await this.updateTransaction(tx, teacher!.id, data);
    });
  }

  async deleteTeacher(id: string) {
    return await prisma.teacher.delete({ where: { id } });
  }
}

export default new TeacherService();
