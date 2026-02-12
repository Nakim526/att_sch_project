import { Response } from "express";
import * as service from "./teacher.service";
import { AuthRequest } from "../../middlewares/auth.middleware";

export async function create(req: AuthRequest, res: Response) {
  const { name, nip, userId, email } = req.body;

  const teacher = await service.createTeacher({
    name,
    nip,
    userId,
    email,
    schoolId: req.user!.schoolId,
  });

  res.status(201).json(teacher);
}

export async function list(req: AuthRequest, res: Response) {
  const data = await service.getAllTeachers(req.user!.schoolId);
  res.json(data);
}

export async function me(req: AuthRequest, res: Response) {
  const teacher = await service.getMyTeacher(req.user!.id);

  if (!teacher) {
    return res.status(404).json({ message: "Teacher not found" });
  }

  res.json(teacher);
}
