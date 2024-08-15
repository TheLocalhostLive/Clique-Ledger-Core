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

// Socket.io connection setup
const userSocketMap = new Map<string, string>();

io.on('connection', (socket) => {
  console.log('New user connected:', socket.id);

  socket.on('userLoggedIn', (userId: string) => {
    userSocketMap.set(userId, socket.id);
    console.log(`User ${userId} is associated with socket ${socket.id}`);
  });

  socket.on('userLoggedOut', (userId: string) => {
    if (userSocketMap.has(userId)) {
      userSocketMap.delete(userId);
      console.log(`User ${userId} has logged out and socket ${socket.id} is removed`);
    }
  });

  socket.on('disconnect', () => {
    console.log('User disconnected:', socket.id);
    for (const [userId, socketId] of userSocketMap.entries()) {
      if (socketId === socket.id) {
        userSocketMap.delete(userId);
        console.log(`User ${userId} has been removed from map due to disconnection`);
        break;
      }
    }
  });

  socket.on('error', (error) => {
    console.error('Socket error:', error);
  });
});

export { io, userSocketMap };

server.listen(port, () => {
  console.log(`Server is running on port ${port}`);
});
