import { NextFunction, Response } from "express";
import service from "./user.service";
import { AuthRequest } from "../../middlewares/auth.middleware";

class UserController {
  async create(req: AuthRequest, res: Response, next: NextFunction) {
    try {
      console.log("REQUEST USER: ", req.user);
      console.log("REQUEST BODY: ", req.body);

      const { schoolId } = req.user as { schoolId: string };
      const result = await service.createUser(schoolId, req.body);

      console.log("RESULT: ", result);
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

      const { schoolId } = req.user as { schoolId: string };
      const result = await service.readUserList(schoolId);

      console.log("RESULT: ", result);
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
      const result = await service.readUserDetail(id);

      console.log("RESULT: ", result);
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
      const { schoolId } = req.user as { schoolId: string };
      const result = await service.updateUser(id, schoolId, req.body);

      console.log("RESULT: ", result);
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
      const user = req.user as { id: string; schoolId: string };
      await service.deleteUser(id, user.schoolId, user.id);

      res.json({ message: "Data berhasil dihapus" });
    } catch (error) {
      next(error);
    }
  }
}

export default new UserController();
