import { Router } from "express";
import controller from "./has-access.controller";
import { authMiddleware } from "../../middlewares/auth.middleware";
import { roleMiddleware } from "../../middlewares/role.middleware";

const router = Router();

router.use(authMiddleware);
router.use(roleMiddleware(["ADMIN", "OPERATOR", "KEPSEK"]));

// Admin / Operator / Kepsek
router.post("/", (req, res, next) => controller.create(req, res, next));

router.get("/", (req, res, next) => controller.readList(req, res, next));

router.get("/all", (req, res, next) => controller.readListForce(req, res, next));

router.get("/:id", (req, res, next) => controller.readDetail(req, res, next));

router.put("/:id", (req, res, next) => controller.update(req, res, next));

router.delete("/:id", (req, res, next) => controller.delete(req, res, next));

export default router;
