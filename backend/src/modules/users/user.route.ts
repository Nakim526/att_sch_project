import { Router } from "express";
import controller from "./user.controller";
import { authMiddleware } from "../../middlewares/auth.middleware";
import { roleMiddleware } from "../../middlewares/role.middleware";

const router = Router();

router.use(authMiddleware);
router.use(roleMiddleware(["ADMIN", "OPERATOR", "KEPSEK"]));

// profile pribadi all user
router.get("/me", controller.me);

router.put("/me", controller.updateMe);

// Admin / Operator / Kepsek
router.post("/", controller.create);

router.get("/", controller.list);

router.get("/:id", controller.detail);

router.put("/:id", controller.update);

router.delete("/:id", controller.delete);

export default router;
