// src/modules/subject/subject.route.ts

import { Router } from "express";
import controller from "./academic-year.controller";
import { authMiddleware } from "../../middlewares/auth.middleware";
import { roleMiddleware } from "../../middlewares/role.middleware";

const router = Router();

/**
 * Subject hanya boleh dikelola oleh:
 * - ADMIN
 * - OPERATOR
 * - KEPSEK
 */
router.use(authMiddleware);
router.use(roleMiddleware(["ADMIN", "OPERATOR", "KEPSEK"]));

router.post("/", (req, res, next) => controller.create(req, res, next));

router.get("/", (req, res, next) => controller.findAll(req, res, next));

router.get("/active", (req, res, next) => controller.findActive(req, res, next));

router.get("/:id", (req, res, next) => controller.findOne(req, res, next));

router.put("/:id", (req, res, next) => controller.update(req, res, next));

router.delete("/:id", (req, res, next) => controller.delete(req, res, next));

export default router;
