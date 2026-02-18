import { NextFunction, Response } from "express";
import service from "./has-access.service";
import { AuthRequest } from "../../middlewares/auth.middleware";

class HasAccessController {
  async create(req: AuthRequest, res: Response, next: NextFunction) {
    try {
      const schoolId = req.user!.schoolId;
      const data = await service.createHasAccess({ schoolId, ...req.body });
      res.status(201).json({
        message: "Data berhasil ditambahkan",
        data: data,
      });
      console.log(data);
    } catch (error) {
      next(error);
    }
  }

  async readList(req: AuthRequest, res: Response, next: NextFunction) {
    try {
      const data = await service.getAllHasAccess();
      res.json({ data: data });
    } catch (error) {
      next(error);
    }
  }

  async readListForce(req: AuthRequest, res: Response, next: NextFunction) {
    try {
      const data = await service.getAllHasAccessForce();
      res.json({ data: data });
    } catch (error) {
      next(error);
    }
  }

  async readDetail(req: AuthRequest, res: Response, next: NextFunction) {
    try {
      const { id } = req.params as { id: string };
      const data = await service.getHasAccessById(id);
      res.json({ data: data });
    } catch (error) {
      next(error);
    }
  }

  async update(req: AuthRequest, res: Response, next: NextFunction) {
    try {
      const { id } = req.params as { id: string };
      const schoolId = req.user!.schoolId;
      const data = await service.updateHasAccess(id, schoolId, req.body);
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
      await service.deleteHasAccess(id);
      res.json({
        message: "Data berhasil dihapus",
      });
    } catch (error) {
      next(error);
    }
  }
}

export default new HasAccessController();
