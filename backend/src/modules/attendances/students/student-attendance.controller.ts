// src/modules/attendance/student-attendance.controller.ts

import { Response, NextFunction } from "express";
import { AuthRequest } from "../../../middlewares/auth.middleware";
import studentAttendanceService from "./student-attendance.service";

class StudentAttendanceController {
  async submit(req: AuthRequest, res: Response, next: NextFunction) {
    try {
      const teacherId = req.user!.id;
      const schoolId = req.user!.schoolId;

      const result = await studentAttendanceService.submitAttendance(
        teacherId,
        schoolId,
        req.body,
      );

      res.status(201).json({
        message: "Absensi siswa berhasil disimpan",
        data: result,
      });
    } catch (error) {
      next(error);
    }
  }

  async findByClassAndSubject(
    req: AuthRequest,
    res: Response,
    next: NextFunction,
  ) {
    try {
      const { classId, subjectId } = req.params as {
        classId: string;
        subjectId: string;
      };

      const { date } = req.query as { date: string };

      const result = await studentAttendanceService.findByClassAndSubject(
        classId,
        subjectId,
        date,
      );

      res.json({ data: result });
    } catch (error) {
      next(error);
    }
  }
}

export default new StudentAttendanceController();
