import { Router } from "express";
import controller from "./school.controller";
import { authMiddleware } from "../../middlewares/auth.middleware";
import { roleMiddleware } from "../../middlewares/role.middleware";

const router = Router();

router.use(authMiddleware);

// Admin / Operator / Kepsek
router.get(
  "/me",
  roleMiddleware(["ADMIN", "OPERATOR", "KEPSEK", "GURU"]),
  controller.me,
);

// Hanya Kepsek
router.put("/me", roleMiddleware(["KEPSEK"]), controller.updateMe);

// Hanya Admin/Developer
router.post("/", roleMiddleware(["ADMIN"]), controller.create);

router.get("/", roleMiddleware(["ADMIN"]), controller.list);

router.get("/:id", roleMiddleware(["ADMIN"]), controller.detail);

router.put("/:id", roleMiddleware(["ADMIN"]), controller.update);

router.delete("/:id", roleMiddleware(["ADMIN"]), controller.delete);


export default router;
