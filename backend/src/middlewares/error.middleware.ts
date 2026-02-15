import { Request, Response, NextFunction } from "express";
import { logger } from "../utils/logger";

export const errorMiddleware = (
  err: any,
  _req: Request,
  res: Response,
  _next: NextFunction,
) => {
  console.error(err);
  logger.error(err);

  res.status(err.statusCode || 500).json({
    message: err.message || "Internal Server Error",
  });
};
