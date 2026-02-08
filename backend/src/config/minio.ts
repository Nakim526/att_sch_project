// src/config/minio.ts

import { Client } from 'minio';
import { env } from './env';

export const minioClient = new Client({
  endPoint: env.MINIO_ENDPOINT!,
  port: Number(env.MINIO_PORT),
  useSSL: env.MINIO_USE_SSL === 'true',
  accessKey: env.MINIO_ACCESS_KEY,
  secretKey: env.MINIO_SECRET_KEY,
});

export const MINIO_BUCKET = env.MINIO_BUCKET!;
