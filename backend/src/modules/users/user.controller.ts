import { NextFunction, Response } from "express";
import service from "./user.service";
import { AuthRequest } from "../../middlewares/auth.middleware";

class UserController {
  async create(req: AuthRequest, res: Response, next: NextFunction) {
    try {
      console.log("REQUEST USER: ", req.user);
      console.log("REQUEST BODY: ", req.body);

      const schoolId = req.user!.schoolId;
      const result = await service.createUser(schoolId, req.body);

      res.status(201).json({
        message: "User baru berhasil dibuat",
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
      const result = await service.readAllUsers(schoolId);

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
      const result = await service.readAllUsers(id);

      res.json({ data: result });
    } catch (error) {
      next(error);
    }
  }

  async me(req: AuthRequest, res: Response, next: NextFunction) {
    try {
      console.log("REQUEST USER: ", req.user);
      console.log("REQUEST BODY: ", req.body);

      const id = req.user!.id;
      const result = await service.readUserSelf(id);

      res.json({ data: result });
    } catch (error) {
      next(error);
    }
  }

  async update(req: AuthRequest, res: Response, next: NextFunction) {
    try {
      console.log("REQUEST USER: ", req.user);
      console.log("REQUEST BODY: ", req.body);

      const id = req.user!.id;
      const result = await service.updateUser(id, req.body);

      res.json({
        message: "Data User berhasil diperbarui",
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
      await service.deleteUser(id);

      res.json({ message: "Data berhasil dihapus" });
    } catch (error) {
      next(error);
    }
  }
}

export default new UserController();
