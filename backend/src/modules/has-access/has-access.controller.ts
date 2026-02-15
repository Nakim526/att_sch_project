import { Response } from "express";
import * as service from "./has-access.service";
import { AuthRequest } from "../../middlewares/auth.middleware";

export async function create(req: AuthRequest, res: Response) {
  console.log(`req.body: ${JSON.stringify(req.body)}`);
  const data = await service.createHasAccess(req.body);
  res.json(data);
}

export async function list(req: AuthRequest, res: Response) {
  console.log(req.user);
  const data = await service.getAllHasAccess();
  res.json(data);
}
