// src/modules/attendance/student-attendance.route.ts

import { Router } from "express";
import studentAttendanceController from "./student-attendance.controller";
import { authMiddleware } from "../../../middlewares/auth.middleware";

const router = Router();

router.post("/students", authMiddleware, studentAttendanceController.submit);

router.get(
  "/students/class/:classId/subject/:subjectId",
  authMiddleware,
  studentAttendanceController.findByClassAndSubject,
);

export default router;
