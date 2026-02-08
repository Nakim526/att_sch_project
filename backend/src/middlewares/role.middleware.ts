import { Response, NextFunction } from "express";
import { AuthRequest } from "./auth.middleware";

export function roleMiddleware(roles: string[]) {
  return (req: AuthRequest, res: Response, next: NextFunction) => {
    const userRoles = req.user?.roles || [];

    const hasAccess = roles.some((r) => userRoles.includes(r));

    if (!hasAccess) {
      return res.status(403).json({ message: "Forbidden" });
    }

    next();

    // if (!req.user) {
    //   return res.status(401).json({ message: "Unauthorized" });
    // }

    // const hasAccess = req.user.roles.some((role) =>
    //   allowedRoles.includes(role)
    // );

    // if (!hasAccess) {
    //   return res.status(403).json({ message: "Forbidden" });
    // }

    // next();
  };
}
