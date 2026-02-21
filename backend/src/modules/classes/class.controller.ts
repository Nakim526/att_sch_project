// src/modules/class/class.controller.ts

import { Response, NextFunction } from "express";
import { AuthRequest } from "../../middlewares/auth.middleware";
import classService from "./class.service";

class ClassController {
  async create(req: AuthRequest, res: Response, next: NextFunction) {
    try {
      const schoolId = req.user!.schoolId;
      const result = await classService.create(schoolId, req.body);

      res.status(201).json({
        message: "Kelas berhasil dibuat",
        data: result,
      });
    } catch (error) {
      next(error);
    }
  }

  async findAll(req: AuthRequest, res: Response, next: NextFunction) {
    try {
      const schoolId = req.user!.schoolId;
      const result = await classService.findAllBySchool(schoolId);

      res.json({ data: result });
    } catch (error) {
      next(error);
    }
  }

  async findOne(req: AuthRequest, res: Response, next: NextFunction) {
    try {
      const { id } = req.params as { id: string };
      const result = await classService.findById(id);

      if (!result) {
        return res.status(404).json({ message: "Kelas tidak ditemukan" });
      }

      res.json({ data: result });
    } catch (error) {
      next(error);
    }
  }

  async update(req: AuthRequest, res: Response, next: NextFunction) {
    try {
      const { id } = req.params as { id: string };
      const { schoolId } = req.user as { schoolId: string };
      const result = await classService.update(id, schoolId, req.body);

      res.json({
        message: "Kelas berhasil diperbarui",
        data: result,
      });
    } catch (error) {
      next(error);
    }
  }

  async delete(req: AuthRequest, res: Response, next: NextFunction) {
    try {
      const { id } = req.params as { id: string };
      const { schoolId } = req.user as { schoolId: string };
      await classService.delete(id, schoolId);

      res.json({
        message: "Kelas berhasil dihapus",
      });
    } catch (error) {
      next(error);
    }
  }
}

export default new ClassController();
