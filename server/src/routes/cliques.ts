import { Router, Request, Response } from 'express';
import {  PrismaClient } from '@prisma/client';
import { boolean, number } from 'zod';
import { error } from 'console';

const prisma = new PrismaClient()

const router = Router();

// get all cliques
router.get('/', async(req: Request, res: Response) => {
  try{
    const allRecords = await prisma.clique.findMany();
    if(allRecords.length === 0) {
      console.log("No data");
      res.status(200).json("No data found");
      return;
    }
    res.status(200).json(allRecords)
    return;
  } catch(err) {
    console.log(err);
    res.status(500).json({error: "An error occurred while fetching records"});
  }
});

// create a new clique and return
router.post('/', async (req: Request, res: Response) => {
  try {
    const name: string = req.body.name;
    const funds: number = req.body.funds;
    let fund_flag: boolean = true;
    if(funds == 0) {
      fund_flag = false;
    }
    //create new clique
    const newClique = await prisma.clique.create({
      data: {
        fund: funds,
        created_at: new Date(),
        is_fund: fund_flag,
        clique_name: name,
      },
      include: {
        members: true,
      },
    });

    res.status(201).json(newClique);
  } catch(err) {
    console.error(err);
    res.status(500).json({ error: 'An error occurred while creating the clique' });
  }
});


// GET a single clique by ID
router.get('/:cliqueId', async (req: Request, res: Response) => {
  try {
    const cliqueId: number = parseInt(req.params.cliqueId);

    if (isNaN(cliqueId)) {
      res.status(400).json({ field_name: 'cliqueId', status: 'INVALID' });
      return;
    }

    const clique = await prisma.clique.findUnique({
      where: {
        clique_id: cliqueId,
      },
      include: {
        members: true,
      },
    });

    if (!clique) {
      res.status(404).json({ message: 'Clique not found' });
      return;
    }

    res.status(200).json(clique);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'An error occurred while fetching the clique' });
  }
});

// Update clique name using clique id
router.patch('/:cliqueId', async (req: Request, res: Response) => {
  try{
    const cliqueId : number = parseInt(req.params.cliqueId);
    const name : string = req.body.name;

    if (isNaN(cliqueId)) {
      return res.status(400).json({ field_name: 'cliqueId', status: 'INVALID' });
    }

    const existingClique = await prisma.clique.findUnique({
      where: {
        clique_id: cliqueId,
      },
    });

    if (!existingClique) {
      return res.status(404).json({ field_name: 'name', status: 'NOT FOUND' });
    }

    // Perform partial update if name is provided
    let updatedClique;
    if (name) {
      updatedClique = await prisma.clique.update({
        where: {
          clique_id: cliqueId,
        },
        data: {
          clique_name: name,
        },
      });
    }

    return res.status(200).json({ field_name: 'name', status: 'SUCCESS' });
  } catch (err) {
    console.error(error);
    return res.status(500).json({ error: 'An error occurred while updating the clique' });
  }
});

// Delete a clique using clique id
router.delete('/:cliqueId', async (req: Request, res: Response) => {
  try{
    const cliqueId : number = parseInt(req.params.cliqueId);
    if (isNaN(cliqueId)) {
      res.status(400).json({ field_name: 'cliqueId', status: 'INVALID' });
      return;
    }

    const deletedClique = await prisma.clique.delete({
      where: {
        clique_id: cliqueId,
      },
    });

    if (!deletedClique) {
      res.status(404).json({ field_name: 'cliqueId', status: 'NOT FOUND' });
      return;
    }

    res.status(204).json({ message: 'Clique deleted successfully' });
  } catch (err) {
    console.error(error);
    res.status(500).json({ error: 'An error occurred while deleting the clique' });
    return;
  }
});

//add members in a clique
router.post('/:cliqueId/members/:userId', async(req: Request, res: Response) => {
  try{
    const cliqueId : number = parseInt(req.params.cliqueId);
    const userId : number = parseInt(req.params.userId);

    const memberName : string = req.body.name;
    const funds : number = parseFloat(req.body.funds);

    const user = await prisma.user.findUnique({
      where: { user_id: userId }
    });

    if (!user) {
      res.status(404).json({ status: 'FAILURE', message: 'User not found' });
      return;
    }

    // Add the member to the clique
    const newMember = await prisma.member.create({
      data: {
        user_id: user.user_id,
        clique_id: cliqueId,
        is_admin: false,
        joined_at: new Date(),
        amount: funds,
        due: false
      }
    });

    res.status(201).json({
      status: 'SUCCESS',
      message: 'Members added successfully',
      data: newMember
    });
  } catch (err) {
    console.error(err);
    res.status(500).json({ status: 'FAILURE', message: 'An error occurred while adding members' });
    return;
  }
});

// remove a member
router.delete('')
export default router;
