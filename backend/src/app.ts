import express from 'express';
import routes from './routes';
import { errorMiddleware } from './middlewares/error.middleware';

const app = express();

app.get('/test-login', (req, res) => res.sendFile('./index.html'));

app.use(express.json());
app.use('/api', routes);
app.use(errorMiddleware);

export default app;
