// src/middlewares/multer.middleware.ts

import multer from "multer";

/**
 * Gunakan memory storage
 * karena file akan langsung dikirim ke MinIO
 */
const storage = multer.memoryStorage();

const upload = multer({
  storage,
  limits: {
    fileSize: 5 * 1024 * 1024, // max 5 MB
  },
  fileFilter: (_req, file, cb) => {
    if (!file.mimetype.startsWith("image/")) {
      return cb(new Error("Hanya file gambar yang diperbolehkan"));
    }
    cb(null, true);
  },
});

export default upload;
