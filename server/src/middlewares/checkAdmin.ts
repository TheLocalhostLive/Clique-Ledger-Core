import { Request, Response, NextFunction } from 'express';
import jwt from 'jsonwebtoken';
import {  PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

// Middleware to check if the user is an admin
const checkAdmin = async (req: Request, res: Response, next: NextFunction) => {
  // try {
  //   const token = req.headers.authorization?.split(' ')[1];

  //   if (!token) {
  //     res.status(401).json({
  //       status: 'FAILURE',
  //       message: 'Access denied. No token provided.',
  //     });
  //     return;
  //   }

  //   const decoded = jwt.verify(token, process.env.JWT_SECRET!) as { id: string };

  //   if (!decoded || !decoded.id) {
  //     res.status(401).json({
  //       status: 'FAILURE',
  //       message: 'Invalid token provided.',
  //     });
  //     return;
  //   }

  //   const userId = decoded.id;

  //   const user = await prisma.member.findUnique({
  //     where: { member_id: userId },
  //   });

  //   if (!user || !user.is_admin) {
  //     res.status(403).json({
  //       status: 'FAILURE',
  //       message: 'Access denied. Only admins can add members to the clique.',
  //     });
  //     return;
  //   }

  //   // Attach user to the request object
  //   if(req.hasOwnProperty('user')) req.user = user;
  //   next(); // User is an admin, proceed to the next middleware/route handler
  // } catch (err) {
  //   console.error(err);
  //   res.status(500).json({ status: 'FAILURE', message: 'An error occurred while checking admin status' });
  // }
};

export default checkAdmin;
