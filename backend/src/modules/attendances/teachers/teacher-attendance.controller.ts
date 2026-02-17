// src/modules/attendance/teacher-attendance.controller.ts

import { Response, NextFunction } from "express";
import { AuthRequest } from "../../../middlewares/auth.middleware";
import service from "./teacher-attendance.service";

class TeacherAttendanceController {
  /**
   * =====================================
   * GURU - CHECK IN
   * POST /attendances/teachers/check-in
   * =====================================
   */
  async checkIn(req: AuthRequest, res: Response, next: NextFunction) {
    try {
      const teacherId = req.user!.id;
      const schoolId = req.user!.schoolId;
      const file = req.file!;
      const { latitude, longitude, status } = req.body;

      const result = await service.checkIn({
        teacherId,
        schoolId,
        photo: file,
        latitude: latitude,
        longitude: longitude,
        status,
      });

      res.status(201).json({
        message: "Check-in berhasil",
        data: result,
      });
    } catch (error) {
      next(error);
    }
  }

  /**
   * =====================================
   * GURU - LIHAT ABSENSI SENDIRI
   * GET /attendances/teachers/me?date=
   * =====================================
   */
  async findMyAttendance(req: AuthRequest, res: Response, next: NextFunction) {
    try {
      const teacherId = req.user!.id;
      const date = req.query.date as string | undefined;

      const result = await service.findMyAttendance({
        teacherId,
        date,
      });

      res.json({ data: result });
    } catch (error) {
      next(error);
    }
  }

  /**
   * =====================================
   * ADMIN / KEPSEK - LIHAT SEMUA GURU
   * GET /attendances/teachers
   * =====================================
   */
  async findAllForAdmin(req: AuthRequest, res: Response, next: NextFunction) {
    try {
      const schoolId = req.user!.schoolId;

      const result = await service.findAllForAdmin(schoolId);

      res.json({ data: result });
    } catch (error) {
      next(error);
    }
  }

  /**
   * =====================================
   * ADMIN / KEPSEK - EXPORT ABSENSI
   * GET /attendances/teachers/export
   * =====================================
   */
  async exportForAdmin(req: AuthRequest, res: Response, next: NextFunction) {
    try {
      const schoolId = req.user!.schoolId;
      const { startDate, endDate } = req.query as {
        startDate?: string;
        endDate?: string;
      };

      const result = await service.exportForAdmin({
        schoolId,
        startDate,
        endDate,
      });

      /**
       * sementara JSON dulu
       * nanti bisa:
       * - PDF
       * - Excel
       */
      res.json({
        message: "Export absensi guru",
        data: result,
      });
    } catch (error) {
      next(error);
    }
  }
}

export default new TeacherAttendanceController();
