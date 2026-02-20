import { Response } from "express";
import { loginWithGoogle } from "./auth.service";
import { AuthRequest } from "../../middlewares/auth.middleware";

export async function googleLogin(req: AuthRequest, res: Response) {
  try {
    const { idToken } = req.body;
    const schoolId = req.user!.schoolId;

    if (!idToken) {
      return res.status(400).json({ message: "idToken required" });
    }

    if (!schoolId) {
      return res.status(400).json({ message: "schoolId not found" });
    }

    const result = await loginWithGoogle(idToken, schoolId);
    res.json(result);
  } catch (err: any) {
    if (err.message === "EMAIL_NOT_ALLOWED") {
      return res.status(403).json({ message: "Email not allowed" });
    }
    if (err.message === "USER_NOT_FOUND") {
      return res.status(404).json({ message: "User not found" });
    }
    if (err.message === "INVALID_GOOGLE_TOKEN") {
      return res.status(401).json({ message: "Invalid Google token" });
    }

    console.error(err);
    res.status(500).json({ message: err.message.split(":")[0] });
  }
}
