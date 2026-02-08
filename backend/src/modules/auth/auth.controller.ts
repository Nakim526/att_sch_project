import { Request, Response } from "express";
import { loginWithGoogle } from "./auth.service";

export async function googleLogin(req: Request, res: Response) {
  try {
    const { idToken } = req.body;

    if (!idToken) {
      return res.status(400).json({ message: "idToken required" });
    }

    const result = await loginWithGoogle(idToken);
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
    res.status(500).json({ message: "Login failed" });
  }
}
