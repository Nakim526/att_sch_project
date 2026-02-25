import prisma from "../../config/prisma";
import {
  ClassScheduleTypes,
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
    const user = await tx.user.findUnique({ where: { email } });

    const emailUsed = await tx.teacher.findFirst({
      where: { userId: user?.id, ...(id && { id: { not: id } }) },
    });

    if (emailUsed) throw new Error(`Email ${email} sudah digunakan`);

    const nipUsed = await tx.teacher.findFirst({
      where: { nip, ...(id && { id: { not: id } }) },
    });

    if (nipUsed) throw new Error(`NIP ${nip} sudah digunakan`);

    return user;
  }

  async assignRole(tx: Prisma.TransactionClient, userId: string) {
    const role = await tx.role.findFirst({ where: { name: RoleName.GURU } });

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
    await tx.teachingAssignment.deleteMany({ where: { teacherId } });

    for (const assignment of data) {
      const teachingAssignment = await tx.teachingAssignment.upsert({
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

      for (const schedule of assignment.schedules) {
        await this.assignSchedule(tx, teachingAssignment.id, schedule);
      }
    }
  }

  async assignSchedule(
    tx: Prisma.TransactionClient,
    teachingAssignmentId: string,
    data: ClassScheduleTypes,
  ) {
    return await tx.classSchedule.upsert({
      where: {
        teachingAssignmentId_dayOfWeek_startTime: {
          teachingAssignmentId,
          dayOfWeek: data.dayOfWeek,
          startTime: data.startTime,
        },
      },
      update: {
        dayOfWeek: data.dayOfWeek,
        startTime: data.startTime,
        endTime: data.endTime,
        room: data.room,
      },
      create: {
        teachingAssignmentId,
        dayOfWeek: data.dayOfWeek,
        startTime: data.startTime,
        endTime: data.endTime,
        room: data.room,
      },
    });
  }

  async createTeacher(schoolId: string, data: CreateTeacherTypes) {
    return await prisma.$transaction(async (tx) => {
      const user = await this.ensureAvailable(tx, data.nip, data.email);

      if (!user) throw new Error("User tidak ditemukan");

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
        teachingAssignments: { include: { schedules: true } },
        classAssignments: true,
      },
    });
  }

  async readTeacherDetail(id: string) {
    return await prisma.teacher.findUnique({
      where: { id },
      include: {
        user: true,
        teachingAssignments: { include: { schedules: true } },
        classAssignments: true,
      },
    });
  }

  async readMySelf(userId: string) {
    return await prisma.teacher.findUnique({
      where: { userId },
      include: {
        user: true,
        teachingAssignments: { include: { schedules: true } },
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
    const oldTeacher = await tx.teacher.findUnique({ where: { id } });

    if (!oldTeacher) throw new Error("Guru tidak ditemukan");

    let user = await this.ensureAvailable(tx, data.nip, data.email, id);

    user = await tx.user.findUnique({ where: { id: oldTeacher.userId } });

    if (!user) throw new Error("User tidak ditemukan");

    await tx.user.update({
      where: { id: user.id },
      data: { email: data.email },
    });

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

      return await this.updateTransaction(tx, teacher.id, data);
    });
  }

  async deleteTeacher(id: string, schoolId: string, userId: string) {
    return await prisma.$transaction(async (tx) => {
      const teacher = await tx.teacher.findUnique({
        where: { id },
        include: {
          classAssignments: true,
          teachingAssignments: true,
        },
      });

      if (!teacher) throw new Error("Guru tidak ditemukan");

      const classAssignment = teacher.classAssignments.length > 0;
      const teachingAssignment = teacher.teachingAssignments.length > 0;

      if (classAssignment || teachingAssignment) {
        const admin = await tx.user.findFirst({
          where: {
            id: userId,
            roles: {
              some: {
                role: {
                  OR: [{ name: RoleName.ADMIN }, { name: RoleName.KEPSEK }],
                },
              },
            },
          },
        });

        if (!admin) {
          throw new Error(
            `Guru memiliki riwayat, hubungi Kepala Sekolah untuk menghapusnya.`,
          );
        }
      }

      await tx.classTeacherAssignment.deleteMany({ where: { teacherId: id } });

      await tx.teachingAssignment.deleteMany({ where: { teacherId: id } });

      return await tx.teacher.delete({ where: { id, schoolId } });
    });
  }
}

export default new TeacherService();
