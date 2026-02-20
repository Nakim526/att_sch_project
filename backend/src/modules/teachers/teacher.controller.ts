import { NextFunction, Response } from "express";
import service from "./teacher.service";
import { AuthRequest } from "../../middlewares/auth.middleware";

class TeacherController {
  async create(req: AuthRequest, res: Response, next: NextFunction) {
    try {
      console.log("REQUEST USER: ", req.user);
      console.log("REQUEST BODY: ", req.body);

      const schoolId = req.user!.schoolId;
      const result = await service.createTeacher(schoolId, req.body);

      res.status(201).json({
        message: "Guru baru berhasil dibuat",
        data: result,
      });
    } catch (error) {
      next(error);
    }
  }

  async list(req: AuthRequest, res: Response, next: NextFunction) {
    try {
      console.log("REQUEST USER: ", req.user);
      console.log("REQUEST BODY: ", req.body);

      const schoolId = req.user!.schoolId;
      const result = await service.readTeachersList(schoolId);

      res.json({ data: result });
    } catch (error) {
      next(error);
    }
  }

  async detail(req: AuthRequest, res: Response, next: NextFunction) {
    try {
      console.log("REQUEST USER: ", req.user);
      console.log("REQUEST BODY: ", req.body);

      const { id } = req.params as { id: string };
      const result = await service.readTeacherDetail(id);

      res.json({ data: result });
    } catch (error) {
      next(error);
    }
  }

  async me(req: AuthRequest, res: Response, next: NextFunction) {
    try {
      console.log("REQUEST USER: ", req.user);
      console.log("REQUEST BODY: ", req.body);

      const userId = req.user!.id;
      const result = await service.readMySelf(userId);

      res.json({ data: result });
    } catch (error) {
      next(error);
    }
  }

  async update(req: AuthRequest, res: Response, next: NextFunction) {
    try {
      console.log("REQUEST USER: ", req.user);
      console.log("REQUEST BODY: ", req.body);

      const { id } = req.params as { id: string };
      const result = await service.updateTeacher(id, req.body);

      res.json({
        message: "Data Guru berhasil diperbarui",
        data: result,
      });
    } catch (error) {
      next(error);
    }
  }

  async updateMe(req: AuthRequest, res: Response, next: NextFunction) {
    try {
      console.log("REQUEST USER: ", req.user);
      console.log("REQUEST BODY: ", req.body);

      const userId = req.user!.id;
      const result = await service.updateMySelf(userId, req.body);

      res.json({
        message: "Data Guru berhasil diperbarui",
        data: result,
      });
    } catch (error) {
      next(error);
    }
  }

  async delete(req: AuthRequest, res: Response, next: NextFunction) {
    try {
      console.log("REQUEST USER: ", req.user);
      console.log("REQUEST BODY: ", req.body);

      const { id } = req.params as { id: string };
      await service.deleteTeacher(id);

      res.json({ message: "Data berhasil dihapus" });
    } catch (error) {
      next(error);
    }
  }
}

export default new TeacherController();
