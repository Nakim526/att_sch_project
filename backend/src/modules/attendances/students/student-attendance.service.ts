// src/modules/attendance/student-attendance.service.ts

import prisma from "../../../config/prisma";
import { CreateStudentAttendanceTypes } from "./student-attendance.types";

class StudentAttendanceService {
  async submitAttendance(
    teacherId: string,
    schoolId: string,
    data: CreateStudentAttendanceTypes,
  ) {
    const { classId, subjectId, attendanceDate, attendances } = data;

    const date = new Date(attendanceDate);

    /**
     * 1️⃣ Validasi guru mengajar subject & class
     */
    const teaching = await prisma.teacherSubject.findFirst({
      where: {
        teacherId,
        classId,
        subjectId,
      },
    });

    if (!teaching) {
      throw new Error("Guru tidak mengajar kelas atau mata pelajaran ini");
    }

    /**
     * 2️⃣ Ambil seluruh siswa dalam kelas
     */
    const students = await prisma.student.findMany({
      where: {
        classId,
        schoolId,
        isActive: true,
      },
      select: { id: true },
    });

    const studentIds = students.map((s) => s.id);

    /**
     * 3️⃣ Validasi semua studentId milik kelas
     */
    for (const item of attendances) {
      if (!studentIds.includes(item.studentId)) {
        throw new Error("Terdapat siswa yang bukan anggota kelas ini");
      }
    }

    /**
     * 4️⃣ Simpan absensi (UPSERT)
     */
    return prisma.$transaction(
      attendances.map((item) =>
        prisma.studentAttendance.upsert({
          where: {
            studentId_subjectId_attendanceDate: {
              studentId: item.studentId,
              subjectId,
              attendanceDate: date,
            },
          },
          update: {
            status: item.status,
            teacherId,
            classId,
          },
          create: {
            studentId: item.studentId,
            teacherId,
            subjectId,
            classId,
            attendanceDate: date,
            status: item.status,
          },
        }),
      ),
    );
  }

  async findByClassAndSubject(
    classId: string,
    subjectId: string,
    date: string,
  ) {
    return prisma.studentAttendance.findMany({
      where: {
        classId,
        subjectId,
        attendanceDate: new Date(date),
      },
      include: {
        student: {
          select: {
            id: true,
            name: true,
            nis: true,
          },
        },
      },
      orderBy: {
        student: { name: "asc" },
      },
    });
  }
}

export default new StudentAttendanceService();
