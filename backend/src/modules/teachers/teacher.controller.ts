import { NextFunction, Response } from "express";
import service from "./teacher.service";
import { AuthRequest } from "../../middlewares/auth.middleware";

class TeacherController {
  async create(req: AuthRequest, res: Response, next: NextFunction) {
    try {
      const userId = req.user!.id;
      const { name, nip, email } = req.body;

      const teacher = await service.createTeacher({
        name,
        email,
        userId,
        nip,
        schoolId: req.user!.schoolId,
      });

      res.status(201).json({
        message: "Teacher created",
        data: teacher,
      });
    } catch (error) {
      next(error);
    }
  }

  async list(req: AuthRequest, res: Response, next: NextFunction) {
    try {
      const data = await service.getAllTeachers(req.user!.schoolId);
      res.json({ data: data });
    } catch (error) {
      next(error);
    }
  }

  async detail(req: AuthRequest, res: Response, next: NextFunction) {
    try {
      const { id } = req.params as { id: string };
      const data = await service.getTeacherById(id);
      res.json({ data: data });
    } catch (error) {
      next(error);
    }
  }

  async me(req: AuthRequest, res: Response, next: NextFunction) {
    try {
      const teacher = await service.getMyTeacher(req.user!.id);

      if (!teacher) {
        return res.status(404).json({ message: "Teacher not found" });
      }

      res.json(teacher);
    } catch (error) {
      next(error);
    }
  }

  async update(req: AuthRequest, res: Response, next: NextFunction) {
    try {
      const { id } = req.params as { id: string };
      const data = await service.updateTeacher({ id, ...req.body });

      res.json({
        message: "Data berhasil diperbarui",
        data: data,
      });
    } catch (error) {
      next(error);
    }
  }

  async updateMe(req: AuthRequest, res: Response, next: NextFunction) {
    try {
      const id = req.user!.id;
      const data = await service.updateTeacher({ id, ...req.body });

      res.json({
        message: "Data berhasil diperbarui",
        data: data,
      });
    } catch (error) {
      next(error);
    }
  }

  async delete(req: AuthRequest, res: Response, next: NextFunction) {
    try {
      const { id } = req.params as { id: string };
      await service.deleteTeacher(id);

      res.json({
        message: "Data berhasil dihapus",
      });
    } catch (error) {
      next(error);
    }
  }
}

export default new TeacherController();
