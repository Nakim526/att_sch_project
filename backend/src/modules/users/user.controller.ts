import { Response } from "express";
import * as service from "./user.service";
import { AuthRequest } from "../../middlewares/auth.middleware";

export async function create(req: AuthRequest, res: Response) {
  const { name, email, roles } = req.body;

  const school = await service.createUser({
    name,
    email,
    roles,
    schoolId: req.user!.schoolId,
  });

  res.status(201).json(school);
}

export async function list(req: AuthRequest, res: Response) {
  const data = await service.getAllUsers(req.user!.schoolId);
  res.json(data);
}

export async function me(req: AuthRequest, res: Response) {
  const user = await service.getMyUser(req.user!.id);

  if (!user) {
    return res.status(404).json({ message: "User not found" });
  }

  res.json(user);
}
