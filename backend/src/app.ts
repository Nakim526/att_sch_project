import express from 'express';
import routes from './routes';
import { errorMiddleware } from './middlewares/error.middleware';
import path from "path";

const app = express();

app.get('/', (req, res) => {
    res.sendFile(path.join(__dirname, '../../public/index.html'));
});

app.use(express.json());
app.use('/api', routes);
app.use(errorMiddleware);

export default app;
