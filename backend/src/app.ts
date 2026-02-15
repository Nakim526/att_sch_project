import express, { Request, Response, NextFunction } from "express";
import routes from "./routes";
import { errorMiddleware } from "./middlewares/error.middleware";
import path from "path";

const app = express();

app.use(express.static(path.join(process.cwd(), "public")));

app.use(express.json());
app.use("/api", routes);
app.use(errorMiddleware);

app.use((err: any, req: Request, res: Response, next: NextFunction) => {
  console.error(err);

  res.status(err.statusCode || 500).json({
    message: err.message || "Internal Server Error",
  });
});

export default app;
