import { Router } from "express";
import controller from "./user.controller";
import { authMiddleware } from "../../middlewares/auth.middleware";
import { roleMiddleware } from "../../middlewares/role.middleware";

const router = Router();

router.use(authMiddleware);

// Admin / Operator / Kepsek
router.post(
  "/",
  roleMiddleware(["ADMIN", "OPERATOR", "KEPSEK"]),
  controller.create,
);

router.get(
  "/",
  roleMiddleware(["ADMIN", "OPERATOR", "KEPSEK"]),
  controller.list,
);

router.get(
  "/me",
  roleMiddleware(["ADMIN", "OPERATOR", "KEPSEK"]),
  controller.me,
);

export default router;
