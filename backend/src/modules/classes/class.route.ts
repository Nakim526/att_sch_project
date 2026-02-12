// src/modules/class/class.route.ts

import { Router } from "express";
import classController from "./class.controller";
import { authMiddleware } from "../../middlewares/auth.middleware";
import { roleMiddleware } from "../../middlewares/role.middleware";

const router = Router();

/**
 * Semua endpoint class:
 * - Wajib login
 * - Hanya ADMIN & KEPSEK
 */
router.use(authMiddleware);
router.use(roleMiddleware(["ADMIN", "KEPSEK"]));

router.post("/", (req, res, next) => classController.create(req, res, next));

router.get("/", (req, res, next) => classController.findAll(req, res, next));

router.get("/:id", (req, res, next) => classController.findOne(req, res, next));

router.put("/:id", (req, res, next) => classController.update(req, res, next));

router.delete("/:id", (req, res, next) =>
  classController.delete(req, res, next),
);

export default router;
