// src/modules/subject/subject.controller.ts

import { Response, NextFunction } from "express";
import { AuthRequest } from "../../middlewares/auth.middleware";
import service from "./academic-year.service";

class AcademicYearController {
  async create(req: AuthRequest, res: Response, next: NextFunction) {
    try {
      const schoolId = req.user!.schoolId;
      const result = await service.create(schoolId, req.body);

      res.status(201).json({
        message: "Tahun Akademik berhasil dibuat",
        data: result,
      });
    } catch (error) {
      next(error);
    }
  }

  async findAll(req: AuthRequest, res: Response, next: NextFunction) {
    try {
      const schoolId = req.user!.schoolId;
      const result = await service.findAllBySchool(schoolId);

      res.json({ data: result });
    } catch (error) {
      next(error);
    }
  }

  async findActive(req: AuthRequest, res: Response, next: NextFunction) {
    try {
      const schoolId = req.user!.schoolId;
      const result = await service.findActive(schoolId);

      res.json({ data: result });
    } catch (error) {
      next(error);
    }
  }

  async findOne(req: AuthRequest, res: Response, next: NextFunction) {
    try {
      const { id } = req.params as { id: string };
      const result = await service.findById(id);

      if (!result) {
        return res
          .status(404)
          .json({ message: "Tahun Akademik tidak ditemukan" });
      }

      res.json({ data: result });
    } catch (error) {
      next(error);
    }
  }

  async update(req: AuthRequest, res: Response, next: NextFunction) {
    try {
      const { id } = req.params as { id: string };
      const result = await service.update(id, req.body);

      res.json({
        message: "Tahun Akademik berhasil diperbarui",
        data: result,
      });
    } catch (error) {
      next(error);
    }
  }

  async delete(req: AuthRequest, res: Response, next: NextFunction) {
    try {
      const { id } = req.params as { id: string };
      await service.delete(id);

      res.json({
        message: "Tahun Akademik berhasil dihapus",
      });
    } catch (error) {
      next(error);
    }
  }
}

export default new AcademicYearController();
