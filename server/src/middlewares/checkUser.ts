import { Request, Response, NextFunction } from "express";
import jwt from 'jsonwebtoken';
import {  PrismaClient } from '@prisma/client';

const checkUser = async (req: Request, res: Response, next: NextFunction) => {

};

export default checkUser;