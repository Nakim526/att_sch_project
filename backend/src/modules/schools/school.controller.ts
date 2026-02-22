import { NextFunction, Response } from "express";
import service from "./school.service";
import { AuthRequest } from "../../middlewares/auth.middleware";

class SchoolController {
  async create(req: AuthRequest, res: Response, next: NextFunction) {
    try {
      console.log(`REQUEST USER: ${req.user}`);
      console.log(`REQUEST BODY: ${req.body}`);

      const user = req.user as { id: string, email: string };
      const result = await service.createSchool(user, req.body);

      res.status(201).json({
        message: "Sekolah berhasil dibuat",
        data: result,
      });
    } catch (error) {
      next(error);
    }
  }

  async list(req: AuthRequest, res: Response, next: NextFunction) {
    try {
      console.log(`REQUEST USER: ${req.user}`);
      console.log(`REQUEST BODY: ${req.body}`);

      const result = await service.getAllSchools();

      res.json({ data: result });
    } catch (error) {
      next(error);
    }
  }

  async me(req: AuthRequest, res: Response, next: NextFunction) {
    try {
      console.log(`REQUEST USER: ${req.user}`);
      console.log(`REQUEST BODY: ${req.body}`);

      const { schoolId } = req.user as { schoolId: string };
      const result = await service.getMySchool(schoolId);

      if (!result) {
        return res.status(404).json({ message: "School not found" });
      }

      res.json({ data: result });
    } catch (error) {
      next(error);
    }
  }

  async detail(req: AuthRequest, res: Response, next: NextFunction) {
    try {
      console.log(`REQUEST USER: ${req.user}`);
      console.log(`REQUEST BODY: ${req.body}`);

      const { id } = req.params as { id: string };
      const result = await service.getSchoolById(id);

      res.json({ data: result });
    } catch (error) {
      next(error);
    }
  }

  async update(req: AuthRequest, res: Response, next: NextFunction) {
    try {
      console.log(`REQUEST USER: ${req.user}`);
      console.log(`REQUEST BODY: ${req.body}`);

      const { id } = req.params as { id: string };
      const result = await service.updateSchool(id, req.body);

      res.json({ message: "Data Sekolah berhasil diperbarui", data: result });
    } catch (error) {
      next(error);
    }
  }

  async updateMe(req: AuthRequest, res: Response, next: NextFunction) {
    try {
      console.log(`REQUEST USER: ${req.user}`);
      console.log(`REQUEST BODY: ${req.body}`);

      const { schoolId } = req.user as { schoolId: string };
      const result = await service.updateSchool(schoolId, req.body);

      res.json({ message: "Data Sekolah berhasil diperbarui", data: result });
    } catch (error) {
      next(error);
    }
  }

  async delete(req: AuthRequest, res: Response, next: NextFunction) {
    try {
      console.log(`REQUEST USER: ${req.user}`);
      console.log(`REQUEST BODY: ${req.body}`);

      const { id } = req.params as { id: string };
      const result = await service.deleteSchool(id);

      res.json({ message: "Data berhasil dihapus", data: result });
    } catch (error) {
      next(error);
    }
  }
}

export default new SchoolController();
