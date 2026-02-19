// src/modules/subject/subject.controller.ts

import { Response, NextFunction } from "express";
import { AuthRequest } from "../../middlewares/auth.middleware";
import service from "./semester.service";
import { SemesterType } from "@prisma/client";

class AcademicYearController {
  async create(req: AuthRequest, res: Response, next: NextFunction) {
    try {
      console.log("REQUEST USER: ", req.user);
      console.log("REQUEST BODY: ", req.body);

      const result = await service.create(req.body);

      res.status(201).json({
        message: "Semester berhasil dibuat",
        data: result,
      });
    } catch (error) {
      next(error);
    }
  }

  async findAll(req: AuthRequest, res: Response, next: NextFunction) {
    try {
      console.log("REQUEST USER: ", req.user);
      console.log("REQUEST BODY: ", req.body);

      const result = await service.findAllBySchool();

      res.json({ data: result });
    } catch (error) {
      next(error);
    }
  }

  async findAcademicYear(req: AuthRequest, res: Response, next: NextFunction) {
    try {
      console.log("REQUEST USER: ", req.user);
      console.log("REQUEST BODY: ", req.body);

      const { id } = req.params as { id: string };

      const result = await service.findAllByAcademicYear(id);

      res.json({ data: result });
    } catch (error) {
      next(error);
    }
  }

  async findType(req: AuthRequest, res: Response, next: NextFunction) {
    try {
      console.log("REQUEST USER: ", req.user);
      console.log("REQUEST BODY: ", req.body);

      const { type } = req.params as { type: SemesterType };

      const result = await service.findAllByType(type);

      res.json({ data: result });
    } catch (error) {
      next(error);
    }
  }

  async findOne(req: AuthRequest, res: Response, next: NextFunction) {
    try {
      console.log("REQUEST USER: ", req.user);
      console.log("REQUEST BODY: ", req.body);

      const { id } = req.params as { id: string };

      const result = await service.findById(id);

      if (!result) {
        return res.status(404).json({ message: "Semester tidak ditemukan" });
      }

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

      const result = await service.update(id, req.body);

      res.json({
        message: "Semester berhasil diperbarui",
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

      await service.delete(id);

      res.json({
        message: "Semester berhasil dihapus",
      });
    } catch (error) {
      next(error);
    }
  }
}

export default new AcademicYearController();
