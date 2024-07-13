import { Router, Request, Response } from 'express';
import {  PrismaClient } from '@prisma/client';

const prisma = new PrismaClient()

const router = Router();

router.get('/', async(req: Request, res: Response) => {
  try{
    const allRecords = await prisma.cliques.findMany();
    if(allRecords.length === 0) {
      console.log("No data");
      res.status(204).json("No data found");
      return;
    }
    res.status(200).json({record: allRecords})
    return;
  } catch(err) {
    console.log(err);
    res.status(500).send("Inernal server error");
  }
});

router.post("/", async(req: Request, res: Response) => {
  const data = req.body;
  //insert
  const id = 1;
  data.id = id;
  res.status(201).json(data);
});


export default router;
