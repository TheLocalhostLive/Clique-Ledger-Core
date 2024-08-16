import express, { Request, Response } from 'express';
import http, { Server as HttpServer } from 'http';
import { Server as SocketIOServer } from 'socket.io';
import cliques from './routes/cliques';
import createTransactionRoute from './routes/transactions';
import users from './routes/users';
import ledgers from './routes/ledgers';

const app = express();
const port = process.env.PORT || 3000;

const server: HttpServer = http.createServer(app);
const io: SocketIOServer = new SocketIOServer(server, {
  cors: {
    origin: process.env.CORS_ORIGIN || '*',
  },
});

app.use(express.json());

// Set up routes
app.use('/api/v1/cliques', cliques);
app.use('/api/v1/transactions', createTransactionRoute(io));
app.use('/api/v1/users', users);
app.use('/api/v1/ledgers', ledgers);

// Test route
app.get('/', (req: Request, res: Response) => {
  res.send('Hello, this is get ...');
});

type UserSocket = {
  userId: string;
  socketId: string;
};


io.on('connection', (socket) => {
  console.log('New user connected:', socket.id);
  
  socket.on('join-rooms', (rooms: string) => {
    console.log(rooms);
    rooms = JSON.parse(rooms);
    if (!Array.isArray(rooms) || !rooms.every(room => typeof room === 'string')) {
      console.error('Invalid rooms data:', rooms);
      return;
    }

    rooms.forEach((room) => {
      socket.join(room);
      console.log(`User joined room: ${room}`);
    });
  });

  

  socket.on('disconnect', () => {
    console.log('User disconnected:', socket.id);
  });

  socket.on('error', (error) => {
    console.error('Socket error:', error);
  });
});

export { io };

server.listen(port, () => {
  console.log(`Server is running on port ${port}`);
});
