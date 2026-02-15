import { Response } from "express";
import service from "./teacher.service";
import { AuthRequest } from "../../middlewares/auth.middleware";

class TeacherController {
  async create(req: AuthRequest, res: Response) {
    const userId = req.user!.id;
    const { name, nip, email } = req.body;

    const teacher = await service.createTeacher({
      name,
      email,
      userId,
      nip,
      schoolId: req.user!.schoolId,
    });

    res.status(201).json(teacher);
  }

  async list(req: AuthRequest, res: Response) {
    const data = await service.getAllTeachers(req.user!.schoolId);
    res.json(data);
  }

  async me(req: AuthRequest, res: Response) {
    const teacher = await service.getMyTeacher(req.user!.id);

    if (!teacher) {
      return res.status(404).json({ message: "Teacher not found" });
    }

    res.json(teacher);
  }
}

export default new TeacherController();
