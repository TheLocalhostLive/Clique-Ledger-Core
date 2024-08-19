import express, { Request, Response } from 'express';
import http, { Server as HttpServer } from 'http';
import { Server as SocketIOServer } from 'socket.io';
import cliques from './routes/cliques';
import createTransactionRoute from './routes/transactions';
import users from './routes/users';
import ledgers from './routes/ledgers';
import getUserInfo from './controllers/getUserInfo';
import * as z from 'zod';
import { PrismaClient } from '@prisma/client';

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


io.use(async (socket, next) => {
  const query = socket.handshake.query;
  const querySchema = z.object({
    token: z.string(),
  });
  let parsedQuery;
  try {
    parsedQuery = querySchema.parse(query);
    const user = await getUserInfo(parsedQuery.token);
    socket.data.user = user;
    socketUidMap.set(user.clique_ledger_app_uid, socket.id);
    next();
  } catch (err) {
    console.log('ERROR::socke.io');
    socket.emit('auth-error', { message: 'Invalid or missing token!!' });
    console.log(err);
    return;
  }
});

io.on('connection', (socket) => {
  console.log('New user connected:', socket.id);

  socket.on('join-rooms', async () => {
    const uid = socket.data.user.clique_ledger_app_uid;
    const prisma = new PrismaClient();
    const rooms = await prisma.clique.findMany({
      where: {
        members: {
          some: {
            user_id: uid,
            is_active: true, 
          },
        },
      },
    });

    rooms.forEach((room) => {
      socket.join(room.clique_id);
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
