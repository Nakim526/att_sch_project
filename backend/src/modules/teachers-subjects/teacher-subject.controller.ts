// src/modules/teacher-subject/teacher-subject.controller.ts

import { Response, NextFunction } from 'express';
import { AuthRequest } from '../../middlewares/auth.middleware';
import teacherSubjectService from './teacher-subject.service';

class TeacherSubjectController {
  async assign(req: AuthRequest, res: Response, next: NextFunction) {
    try {
      const result = await teacherSubjectService.assign(req.body);

      res.status(201).json({
        message: 'Guru berhasil di-assign ke kelas & mata pelajaran',
        data: result,
      });
    } catch (error) {
      next(error);
    }
  }

  async findAll(req: AuthRequest, res: Response, next: NextFunction) {
    try {
      const schoolId = req.user!.schoolId;
      const result = await teacherSubjectService.findAllBySchool(schoolId);

      res.json({ data: result });
    } catch (error) {
      next(error);
    }
  }

  async mySubjects(req: AuthRequest, res: Response, next: NextFunction) {
    try {
      const teacherId = req.user!.id;
      const result = await teacherSubjectService.findByTeacher(teacherId);

      res.json({ data: result });
    } catch (error) {
      next(error);
    }
  }

  async delete(req: AuthRequest, res: Response, next: NextFunction) {
    try {
      const { id } = req.params as { id: string };
      await teacherSubjectService.delete(id);

      res.json({ message: 'Relasi berhasil dihapus' });
    } catch (error) {
      next(error);
    }
  }
}

export default new TeacherSubjectController();
