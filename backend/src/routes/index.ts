import { Router } from "express";
import authRoutes from "../modules/auth/auth.route";
import roleRoutes from "../modules/roles/role.route";
import userRoutes from "../modules/users/user.route";
import hasAccessRoutes from "../modules/has-access/has-access.route";
import schoolRoutes from "../modules/schools/school.route";
import teacherRoutes from "../modules/teachers/teacher.route";
import classRoutes from "../modules/classes/class.route";
import subjectRoutes from "../modules/subjects/subject.route";
import teacherSubjectRoutes from "../modules/teaching-assignment/teacher-subject.route";
import studentRoutes from "../modules/students/student.route";
import studentAttendanceRoute from "../modules/attendances/students/student-attendance.route";
import { minioClient, MINIO_BUCKET } from "../config/minio";

async function ensureMinioBucket() {
  const exists = await minioClient.bucketExists(MINIO_BUCKET);
  if (!exists) {
    await minioClient.makeBucket(MINIO_BUCKET, "us-east-1");
    console.log(`Bucket "${MINIO_BUCKET}" dibuat`);
  }
}

ensureMinioBucket();

const router = Router();

router.use("/auth", authRoutes);
router.use("/roles", roleRoutes);
router.use("/users", userRoutes);
router.use("/has-access", hasAccessRoutes);
router.use("/schools", schoolRoutes);
router.use("/teachers", teacherRoutes);
router.use("/classes", classRoutes);
router.use("/subjects", subjectRoutes);
router.use("/teacher-subjects", teacherSubjectRoutes);
router.use("/students", studentRoutes);
router.use("/attendances", studentAttendanceRoute);

export default router;
