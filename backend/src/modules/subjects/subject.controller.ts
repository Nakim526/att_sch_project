// src/modules/subject/subject.controller.ts

import { Response, NextFunction } from "express";
import { AuthRequest } from "../../middlewares/auth.middleware";
import subjectService from "./subject.service";

class SubjectController {
  async create(req: AuthRequest, res: Response, next: NextFunction) {
    try {
      const schoolId = req.user!.schoolId;
      const result = await subjectService.create(schoolId, req.body);

      res.status(201).json({
        message: "Mata pelajaran berhasil dibuat",
        data: result,
      });
    } catch (error) {
      next(error);
    }
  }

  async findAll(req: AuthRequest, res: Response, next: NextFunction) {
    try {
      const schoolId = req.user!.schoolId;
      const result = await subjectService.findAllBySchool(schoolId);

      res.json({ data: result });
    } catch (error) {
      next(error);
    }
  }

  async findOne(req: AuthRequest, res: Response, next: NextFunction) {
    try {
      const { id } = req.params as { id: string };
      const result = await subjectService.findById(id);

      if (!result) {
        return res
          .status(404)
          .json({ message: "Mata pelajaran tidak ditemukan" });
      }

      res.json({ data: result });
    } catch (error) {
      next(error);
    }
  }

  async update(req: AuthRequest, res: Response, next: NextFunction) {
    try {
      const { id } = req.params as { id: string };
      const result = await subjectService.update(id, req.body);

      res.json({
        message: "Mata pelajaran berhasil diperbarui",
        data: result,
      });
    } catch (error) {
      next(error);
    }
  }

  async delete(req: AuthRequest, res: Response, next: NextFunction) {
    try {
      const { id } = req.params as { id: string };
      await subjectService.delete(id);

      res.json({
        message: "Mata pelajaran berhasil dihapus",
      });
    } catch (error) {
      next(error);
    }
  }
}

export default new SubjectController();
