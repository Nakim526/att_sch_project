import { Response, NextFunction } from "express";
import { AuthRequest } from "./auth.middleware";

export function roleMiddleware(roles: string[]) {
  return (req: AuthRequest, res: Response, next: NextFunction) => {
    const userRoles = req.user?.roles || [];

    const hasAccess = roles.some((r) => userRoles.includes(r));

    if (!hasAccess) {
      return res.status(403).json({ message: "Akses Ditolak" });
    }

    next();
  };
}
