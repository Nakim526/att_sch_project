import { Router } from "express";
import { googleLogin } from "./auth.controller";
import { authMiddleware, AuthRequest } from "../../middlewares/auth.middleware";

const router = Router();

/// Login with Google
/// localhost:3000/api/auth/google
/// required { idToken: string }
router.post("/google", googleLogin);

// ✅ CHECK SESSION
router.get("/check", authMiddleware, (req: AuthRequest, res) => {
  res.status(200).json({
    valid: true,
    user: req.user,
  });
});

export default router;
