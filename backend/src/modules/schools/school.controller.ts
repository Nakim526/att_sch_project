import { Response } from "express";
import * as service from "./school.service";
import { AuthRequest } from "../../middlewares/auth.middleware";

export async function create(req: AuthRequest, res: Response) {
  const { name, address } = req.body;

  const school = await service.createSchool({
    name,
    address,
  });

  res.status(201).json(school);
}

export async function list(req: AuthRequest, res: Response) {
  console.log(req.user);
  const data = await service.getAllSchools(req.user!.schoolId);
  res.json(data);
}

export async function me(req: AuthRequest, res: Response) {
  const school = await service.getMySchool(req.user!.schoolId);

  if (!school) {
    return res.status(404).json({ message: "School not found" });
  }

  res.json(school);
}
