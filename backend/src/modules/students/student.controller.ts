// src/modules/student/student.controller.ts

import { Response, NextFunction } from "express";
import { AuthRequest } from "../../middlewares/auth.middleware";
import studentService from "./student.service";

class StudentController {
  async create(req: AuthRequest, res: Response, next: NextFunction) {
    try {
      const schoolId = req.user!.schoolId;
      const result = await studentService.create(schoolId, req.body);

      res.status(201).json({
        message: "Siswa berhasil ditambahkan",
        data: result,
      });
    } catch (error) {
      next(error);
    }
  }

  async findAll(req: AuthRequest, res: Response, next: NextFunction) {
    try {
      const schoolId = req.user!.schoolId;
      const result = await studentService.findAllBySchool(schoolId);

      res.json({ data: result });
    } catch (error) {
      next(error);
    }
  }

  async findByClass(req: AuthRequest, res: Response, next: NextFunction) {
    try {
      const { classId } = req.params as { classId: string };
      const result = await studentService.findByClass(classId);

      res.json({ data: result });
    } catch (error) {
      next(error);
    }
  }

  async update(req: AuthRequest, res: Response, next: NextFunction) {
    try {
      const { id } = req.params as { id: string };
      const result = await studentService.update(id, req.body);

      res.json({
        message: "Data siswa berhasil diperbarui",
        data: result,
      });
    } catch (error) {
      next(error);
    }
  }

  async delete(req: AuthRequest, res: Response, next: NextFunction) {
    try {
      const { id } = req.params as { id: string };
      await studentService.delete(id);

      res.json({
        message: "Siswa berhasil dihapus",
      });
    } catch (error) {
      next(error);
    }
  }
}

export default new StudentController();
