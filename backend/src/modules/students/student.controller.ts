// src/modules/student/student.controller.ts

import { Response, NextFunction } from "express";
import { AuthRequest } from "../../middlewares/auth.middleware";
import studentService from "./student.service";

class StudentController {
  async create(req: AuthRequest, res: Response, next: NextFunction) {
    try {
      console.log(req.body);

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
      console.log(req.body);

      const schoolId = req.user!.schoolId;
      const result = await studentService.findAllBySchool(schoolId);

      res.json({ data: result });
    } catch (error) {
      next(error);
    }
  }

  async findOne(req: AuthRequest, res: Response, next: NextFunction) {
    try {
      console.log(req.body);

      const { id } = req.params as { id: string };
      const result = await studentService.findOneById(id);

      res.json({ data: result });
    } catch (error) {
      next(error);
    }
  }

  async findAllByClass(req: AuthRequest, res: Response, next: NextFunction) {
    try {
      console.log(req.body);

      const { classId } = req.params as { classId: string };
      const result = await studentService.findAllByClass(classId);

      res.json({ data: result });
    } catch (error) {
      next(error);
    }
  }

  async findOneByClass(req: AuthRequest, res: Response, next: NextFunction) {
    try {
      console.log(req.body);

      const { classId, id } = req.params as { classId: string; id: string };
      const result = await studentService.findOneByClass(classId, id);

      res.json({ data: result });
    } catch (error) {
      next(error);
    }
  }

  async update(req: AuthRequest, res: Response, next: NextFunction) {
    try {
      console.log(req.body);

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

  async softDelete(req: AuthRequest, res: Response, next: NextFunction) {
    try {
      console.log(req.body);

      const { id } = req.params as { id: string };
      await studentService.softDelete(id);

      res.json({
        message: "Siswa berhasil dihapus",
      });
    } catch (error) {
      next(error);
    }
  }

  async hardDelete(req: AuthRequest, res: Response, next: NextFunction) {
    try {
      console.log(req.body);

      const { id } = req.params as { id: string };
      await studentService.hardDelete(id);

      res.json({
        message: "Siswa berhasil dihapus",
      });
    } catch (error) {
      next(error);
    }
  }
}

export default new StudentController();
