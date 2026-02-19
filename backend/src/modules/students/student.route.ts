// src/modules/student/student.route.ts

import { Router } from "express";
import controller from "./student.controller";
import { authMiddleware } from "../../middlewares/auth.middleware";
import { roleMiddleware } from "../../middlewares/role.middleware";

const router = Router();
router.use(authMiddleware);

/**
 * ADMIN & KEPSEK
 */
router.post("/", roleMiddleware(["ADMIN", "KEPSEK"]), (req, res, next) =>
  controller.create(req, res, next),
);

router.get("/", roleMiddleware(["ADMIN", "KEPSEK"]), (req, res, next) =>
  controller.findAll(req, res, next),
);

router.get(
  "/:id",
  roleMiddleware(["ADMIN", "KEPSEK", "GURU"]),
  (req, res, next) => controller.findOne(req, res, next),
);

router.get(
  "/class/:classId",
  roleMiddleware(["ADMIN", "KEPSEK", "GURU"]),
  (req, res, next) => controller.findAllByClass(req, res, next),
);

router.get(
  "/class/:classId/:id",
  roleMiddleware(["ADMIN", "KEPSEK", "GURU"]),
  (req, res, next) => controller.findOneByClass(req, res, next),
);

router.put("/:id", roleMiddleware(["ADMIN", "KEPSEK"]), (req, res, next) =>
  controller.update(req, res, next),
);

router.put("/:id", roleMiddleware(["ADMIN", "KEPSEK"]), (req, res, next) =>
  controller.softDelete(req, res, next),
);

router.delete("/delete/:id", roleMiddleware(["ADMIN", "KEPSEK"]), (req, res, next) =>
  controller.hardDelete(req, res, next),
);

export default router;
