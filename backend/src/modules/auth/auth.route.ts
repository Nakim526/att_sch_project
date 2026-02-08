import { Router } from "express";
import { googleLogin } from "./auth.controller";

const router = Router();

/// Login with Google
/// localhost:3000/api/auth/google
/// required { idToken: string }
router.post("/google", googleLogin);

export default router;
