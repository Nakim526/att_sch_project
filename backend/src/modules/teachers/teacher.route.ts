import { Router } from "express";
import controller from "./teacher.controller";
import { authMiddleware } from "../../middlewares/auth.middleware";
import { roleMiddleware } from "../../middlewares/role.middleware";

const router = Router();

router.use(authMiddleware);

// Guru
router.get("/me", roleMiddleware(["GURU"]), controller.readMe);

router.put("/me", roleMiddleware(["GURU"]), controller.updateMe);

// baca detail guru lain
router.get(
  "/:id",
  roleMiddleware(["ADMIN", "OPERATOR", "KEPSEK", "GURU"]),
  controller.detail,
);

// Admin / Operator / Kepsek
router.use(roleMiddleware(["ADMIN", "OPERATOR", "KEPSEK"]));

router.post("/", controller.create);

router.get("/", controller.list);

router.put("/:id", controller.update);

router.delete("/:id", controller.delete);

export default router;
