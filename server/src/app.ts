import express, { Request, Response } from 'express';
import cliques from './routes/cliques';

const app = express();
const port = process.env.PORT || 3000;


app.use(express.json());


app.use('/api/v1/cliques', cliques);


app.get('/', (req: Request, res: Response) => {
  res.send('Hello, world!69');
});


app.listen(port, () => {
  console.log(`Changed Server is running on port ${port}`);
});
