// src/modules/student/student.route.ts

import { Router } from 'express';
import controller from './student.controller';
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
  (req, res, next) => controller.create(req, res, next)
);

router.get(
  '/',
  roleMiddleware(['ADMIN', 'KEPALA_SEKOLAH']),
  (req, res, next) => controller.findAll(req, res, next)
);

router.get(
  '/class/:classId',
  roleMiddleware(['ADMIN', 'KEPALA_SEKOLAH', 'GURU']),
  (req, res, next) => controller.findByClass(req, res, next)
);

router.put(
  '/:id',
  roleMiddleware(['ADMIN', 'KEPALA_SEKOLAH']),
  (req, res, next) => controller.update(req, res, next)
);

router.delete(
  '/:id',
  roleMiddleware(['ADMIN', 'KEPALA_SEKOLAH']),
  (req, res, next) => controller.delete(req, res, next)
);

export default router;
