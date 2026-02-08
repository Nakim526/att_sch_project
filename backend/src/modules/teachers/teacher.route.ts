import { Router } from "express";
import * as controller from "./teacher.controller";
import { authMiddleware } from "../../middlewares/auth.middleware";
import { roleMiddleware } from "../../middlewares/role.middleware";

const router = Router();

router.use(authMiddleware);

// Admin / Operator / Kepsek
router.post("/", roleMiddleware(["ADMIN", "OPERATOR", "KEPSEK"]), controller.create);
router.get("/", roleMiddleware(["ADMIN", "OPERATOR", "KEPSEK"]), controller.list);

// Guru
router.get("/me", roleMiddleware(["GURU"]), controller.me);

export default router;
