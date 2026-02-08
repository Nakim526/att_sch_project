// src/modules/attendance/teacher-attendance.service.ts

import prisma from "../../../config/prisma";
import { minioClient, MINIO_BUCKET } from "../../../config/minio";
import { TeacherCheckInTypes } from "./teacher-attendance.types";
import { v4 as uuidv4 } from "uuid";
import path from "path";

class TeacherAttendanceService {
  /**
   * =========================
   * Upload photo ke MinIO
   * =========================
   */
  private async uploadPhoto(file: Express.Multer.File): Promise<string> {
    if (!file) {
      throw new Error("Foto wajib diunggah");
    }

    if (!file.mimetype.startsWith("image/")) {
      throw new Error("File harus berupa gambar");
    }

    const ext = path.extname(file.originalname);
    const objectName = `teacher-attendance/${uuidv4()}${ext}`;

    const bucketExists = await minioClient.bucketExists(MINIO_BUCKET);
    if (!bucketExists) {
      await minioClient.makeBucket(MINIO_BUCKET, "us-east-1");
    }

    await minioClient.putObject(
      MINIO_BUCKET,
      objectName,
      file.buffer,
      file.size,
      {
        "Content-Type": file.mimetype,
      },
    );

    return `${MINIO_BUCKET}/${objectName}`;
  }

  /**
   * =========================
   * GURU CHECK-IN
   * =========================
   */
  async checkIn(types: TeacherCheckInTypes) {
    const { teacherId, schoolId, photo, latitude, longitude } = types;

    const today = new Date();
    today.setHours(0, 0, 0, 0);

    // Cegah check-in ganda
    const exists = await prisma.teacherAttendance.findFirst({
      where: {
        teacherId,
        attendanceDate: today,
      },
    });

    if (exists) {
      throw new Error("Anda sudah melakukan check-in hari ini");
    }

    const photoUrl = await this.uploadPhoto(photo);

    return prisma.teacherAttendance.create({
      data: {
        teacherId,
        attendanceDate: today,
        checkInTime: new Date(),
        latitude,
        longitude,
        photoUrl,
      },
    });
  }

  /**
   * =========================
   * GURU LIHAT ABSENSI SENDIRI
   * =========================
   */
  async findMyAttendance(params: { teacherId: string; date?: string }) {
    const { teacherId, date } = params;

    return prisma.teacherAttendance.findMany({
      where: {
        teacherId,
        attendanceDate: date ? new Date(date) : undefined,
      },
      orderBy: {
        attendanceDate: "desc",
      },
    });
  }

  /**
   * =========================
   * ADMIN / KEPSEK - LIHAT SEMUA
   * =========================
   */
  async findAllForAdmin(
    schoolId: string,
    query?: {
      date?: string;
      startDate?: string;
      endDate?: string;
      teacherId?: string;
    },
  ) {
    const { date, startDate, endDate, teacherId } = query || {};

    return prisma.teacherAttendance.findMany({
      where: {
        teacherId: teacherId || undefined,
        attendanceDate: date
          ? new Date(date)
          : startDate && endDate
            ? {
                gte: new Date(startDate),
                lte: new Date(endDate),
              }
            : undefined,
        teacher: {
          schoolId,
        },
      },
      include: {
        teacher: {
          select: {
            id: true,
            name: true,
            nip: true,
            user: {
              select: {
                email: true,
              },
            },
          },
        },
      },
      orderBy: {
        attendanceDate: "desc",
      },
    });
  }

  /**
   * =========================
   * ADMIN / KEPSEK - EXPORT
   * =========================
   */
  async exportForAdmin(params: {
    schoolId: string;
    startDate?: string;
    endDate?: string;
  }) {
    const { schoolId, startDate, endDate } = params;

    return prisma.teacherAttendance.findMany({
      where: {
        attendanceDate:
          startDate && endDate
            ? {
                gte: new Date(startDate),
                lte: new Date(endDate),
              }
            : undefined,
        teacher: {
          schoolId,
        },
      },
      include: {
        teacher: {
          select: {
            name: true,
            nip: true,
            user: {
              select: {
                email: true,
              },
            },
          },
        },
      },
      orderBy: {
        attendanceDate: "asc",
      },
    });
  }
}

export default new TeacherAttendanceService();
