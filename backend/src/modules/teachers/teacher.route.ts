import { Router } from "express";
import controller from "./teacher.controller";
import { authMiddleware } from "../../middlewares/auth.middleware";
import { roleMiddleware } from "../../middlewares/role.middleware";

const router = Router();

router.use(authMiddleware);

// Guru
router.get("/me", roleMiddleware(["GURU"]), controller.me);

router.put("/me", roleMiddleware(["GURU"]), controller.updateMe);

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
  "/:id",
  roleMiddleware(["ADMIN", "OPERATOR", "KEPSEK"]),
  controller.detail,
);

router.put(
  "/:id",
  roleMiddleware(["ADMIN", "OPERATOR", "KEPSEK"]),
  controller.update,
);

router.delete(
  "/:id",
  roleMiddleware(["ADMIN", "OPERATOR", "KEPSEK"]),
  controller.delete,
);

export default router;
