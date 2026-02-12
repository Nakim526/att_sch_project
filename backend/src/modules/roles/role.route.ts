import { Router } from "express";
import * as controller from "./role.controller";
import { authMiddleware } from "../../middlewares/auth.middleware";
import { roleMiddleware } from "../../middlewares/role.middleware";

const router = Router();

router.use(authMiddleware);

// Admin / Operator / Kepsek
router.get("/", roleMiddleware(["ADMIN", "OPERATOR", "KEPSEK"]), controller.list);

export default router;
