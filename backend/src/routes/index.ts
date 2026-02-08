import { Router } from "express";
import authRoutes from "../modules/auth/auth.route";
import teacherRoutes from "../modules/teachers/teacher.route";
import classRoutes from "../modules/classes/class.route";
import subjectRoutes from "../modules/subjects/subject.route";
import teacherSubjectRoutes from "../modules/teachers-subjects/teacher-subject.route";
import studentRoutes from "../modules/students/student.route";
import studentAttendanceRoute from "../modules/attendances/students/student-attendance.route";

const router = Router();

router.use("/auth", authRoutes);
router.use("/teachers", teacherRoutes);
router.use("/classes", classRoutes);
router.use("/subjects", subjectRoutes);
router.use("/teacher-subjects", teacherSubjectRoutes);
router.use("/students", studentRoutes);
router.use("/attendances", studentAttendanceRoute);

export default router;
