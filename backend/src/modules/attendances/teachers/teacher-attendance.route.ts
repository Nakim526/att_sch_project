// src/modules/attendance/teacher-attendance.route.ts

import { Router } from "express";
import controller from "./teacher-attendance.controller";
import { authMiddleware } from "../../../middlewares/auth.middleware";
import { roleMiddleware } from "../../../middlewares/role.middleware";
import upload from "../../../middlewares/multer.middleware";

const router = Router();

/**
 * ===============================
 * GURU
 * ===============================
 */

/**
 * Check-in absensi guru
 * POST /attendances/teachers/check-in
 */
router.post(
  "/teachers/check-in",
  authMiddleware,
  roleMiddleware(["GURU"]),
  upload.single("photo"),
  controller.checkIn,
);

/**
 * Lihat absensi guru sendiri
 * GET /attendances/teachers/me?date=YYYY-MM-DD
 */
router.get(
  "/teachers/me",
  authMiddleware,
  roleMiddleware(["GURU"]),
  controller.findMyAttendance,
);

/**
 * ===============================
 * ADMIN / KEPSEK
 * ===============================
 */

/**
 * Lihat seluruh absensi guru
 * GET /attendances/teachers
 */
router.get(
  "/teachers",
  authMiddleware,
  roleMiddleware(["ADMIN", "KEPSEK"]),
  controller.findAllForAdmin,
);

/**
 * Export / cetak absensi guru
 * GET /attendances/teachers/export?startDate=&endDate=
 */
router.get(
  "/teachers/export",
  authMiddleware,
  roleMiddleware(["ADMIN", "KEPSEK"]),
  controller.exportForAdmin,
);

export default router;
