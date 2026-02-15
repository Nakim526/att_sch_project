import { Router } from "express";
import * as controller from "./has-access.controller";
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

export default router;
