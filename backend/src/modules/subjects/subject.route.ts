// src/modules/subject/subject.route.ts

import { Router } from "express";
import subjectController from "./subject.controller";
import { authMiddleware } from "../../middlewares/auth.middleware";
import { roleMiddleware } from "../../middlewares/role.middleware";

const router = Router();

/**
 * Subject hanya boleh dikelola oleh:
 * - ADMIN
 * - KEPSEK
 */
router.use(authMiddleware);
router.use(roleMiddleware(["ADMIN", "KEPSEK"]));

router.post("/", (req, res, next) => subjectController.create(req, res, next));

router.get("/", (req, res, next) => subjectController.findAll(req, res, next));

router.get("/:id", (req, res, next) =>
  subjectController.findOne(req, res, next),
);

router.put("/:id", (req, res, next) =>
  subjectController.update(req, res, next),
);

router.delete("/:id", (req, res, next) =>
  subjectController.delete(req, res, next),
);

export default router;
