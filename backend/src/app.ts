import express, { Request, Response, NextFunction } from "express";
import routes from "./routes";
import { errorMiddleware } from "./middlewares/error.middleware";
import path from "path";

const app = express();

app.use(express.static(path.join(process.cwd(), "public")));

app.use(express.json());
app.use("/api", routes);
app.use(errorMiddleware);

export default app;
