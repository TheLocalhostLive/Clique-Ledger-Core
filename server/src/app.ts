import express, { Request, Response } from 'express';
import cliques from './routes/cliques';
import transactions from './routes/transactions';
import users from './routes/users';

const app = express();
const port = process.env.PORT || 3000;


app.use(express.json());


app.use('/api/v1/cliques', cliques);
app.use('/api/v1/transactions', transactions);
app.use('/api/v1/users', users);

app.get('/', (req: Request, res: Response) => {
  res.send('hello, this is get ...');
});


app.listen(port, () => {
  console.log(`Changed Server is running on port ${port}`);
});
