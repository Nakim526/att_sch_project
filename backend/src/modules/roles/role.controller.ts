import { Response } from "express";
import * as service from "./role.service";
import { AuthRequest } from "../../middlewares/auth.middleware";

export async function list(req: AuthRequest, res: Response) {
  console.log(req.user);
  const data = await service.getAllRoles();
  res.json(data);
}
