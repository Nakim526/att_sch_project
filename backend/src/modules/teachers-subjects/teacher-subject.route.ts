// src/modules/teacher-subject/teacher-subject.route.ts

import { Router } from 'express';
import controller from './teacher-subject.controller';
import { authMiddleware } from '../../middlewares/auth.middleware';
import { roleMiddleware } from '../../middlewares/role.middleware';

const router = Router();

router.use(authMiddleware);

/**
 * ADMIN & KEPSEK
 */
router.post(
  '/',
  roleMiddleware(['ADMIN', 'KEPALA_SEKOLAH']),
  (req, res, next) => controller.assign(req, res, next)
);

router.get(
  '/',
  roleMiddleware(['ADMIN', 'KEPALA_SEKOLAH']),
  (req, res, next) => controller.findAll(req, res, next)
);

router.delete(
  '/:id',
  roleMiddleware(['ADMIN', 'KEPALA_SEKOLAH']),
  (req, res, next) => controller.delete(req, res, next)
);

/**
 * GURU — hanya lihat miliknya
 */
router.get(
  '/me',
  roleMiddleware(['GURU']),
  (req, res, next) => controller.mySubjects(req, res, next)
);

export default router;
