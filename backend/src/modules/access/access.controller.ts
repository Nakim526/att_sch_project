import { Response } from "express";
import * as service from "./access.service";
import { AuthRequest } from "../../middlewares/auth.middleware";

export async function create(req: AuthRequest, res: Response) {
  console.log(`req.body: ${JSON.stringify(req.body)}`);
  const data = await service.createAccess(req.body);
  res.json(data);
}

export async function list(req: AuthRequest, res: Response) {
  console.log(req.user);
  const data = await service.getAllAccess();
  res.json(data);
}
