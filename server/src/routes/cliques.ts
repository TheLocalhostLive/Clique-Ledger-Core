import { Router, Request, Response, response } from 'express';
import {  PrismaClient } from '@prisma/client';
import { boolean, number } from 'zod';
import { error } from 'console';
import checkAdmin from '../middlewares/checkAdmin';

const prisma = new PrismaClient()

const router = Router();

//generate a new clique id
async function generateCliqueId() {
  const latestClique = await prisma.clique.findFirst({
    orderBy: { clique_id: 'desc' },
  });

  let newId;
  if (latestClique) {
    const latestIdNumber = parseInt(latestClique.clique_id.slice(1));
    newId = `C${(latestIdNumber + 1).toString().padStart(6, '0')}`;
  } else {
    newId = 'C000001';
  }

  return newId;
}

//generater a new member id
async function generateMemberId() {
  const latestUser = await prisma.member.findFirst({
    orderBy: { member_id: 'desc' },
  });

  let newId;
  if (latestUser) {
    const latestIdNumber = parseInt(latestUser.member_id.slice(1));
    newId = `M${(latestIdNumber + 1).toString().padStart(7, '0')}`;
  } else {
    newId = 'M0000001';
  }

  return newId;
}

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
    const newCliqueId = await generateCliqueId();
    const newClique = await prisma.clique.create({
      data: {
        clique_id: newCliqueId,
        fund: funds,
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
    const cliqueId: string = req.params.cliqueId;

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
    const cliqueId : string = req.params.cliqueId;
    const name : string = req.body.name;

    const existingClique = await prisma.clique.findUnique({
      where: {
        clique_id: cliqueId,
      },
    });

    if (!existingClique) {
      return res.status(404).json({ field_name: 'name', status: 'NOT FOUND' });
    }

    // Perform partial update if name is provided
    if (name) {
      await prisma.clique.update({
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
    const cliqueId : string = req.params.cliqueId;

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
router.post('/:cliqueId/members/', checkAdmin, async(req: Request, res: Response) => {
  try{
    const cliqueId : string = req.params.cliqueId;
    const userIds: string[] = req.body;

    // Check if userIds is an array
    if (!Array.isArray(userIds)) {
      res.status(400).json({
        status: 'FAILURE',
        message: 'Invalid input format. Expected an array of user IDs.',
      });
      return;
    }

    // Initialize an array to store the new members
    const newMembers = [];

    // Loop through the user IDs and add each to the clique
    for (const userId of userIds) {
      const newMemberId = await generateMemberId();

      const newMember = await prisma.member.create({
        data: {
          member_id: newMemberId,
          user_id: userId,
          clique_id: cliqueId,
          is_admin: false,
          joined_at: new Date(),
          amount: 0,
          due: false,
        },
      });

      newMembers.push(newMember);
    }

    res.status(201).json({
      status: 'SUCCESS',
      message: 'Members added successfully',
      data: newMembers,
    });
  } catch (err) {
    console.error(err);
    res.status(500).json({ status: 'FAILURE', message: 'An error occurred while adding members' });
    return;
  }
});

// remove a member
router.delete('/clique/:cliqueId/members/', checkAdmin, async (req: Request, res: Response) =>{
  try {
    const cliqueId : string = req.params.cliqueId;
    const userIds: string[] = req.body;

    // Check if userIds is an array
    if (!Array.isArray(userIds)) {
      res.status(400).json({
        status: 'FAILURE',
        message: 'Invalid input format. Expected an array of user IDs.',
      });
      return;
    }

    for (const userId of userIds) {
      await prisma.member.delete({
        where: {member_id: userId},
      });
    }
    res.status(204).json({
      status: 'SUCCESS',
      message: 'Members removed successfully',
    });
  } catch (err) {
    console.log(err);
    res.status(500).json({ status: 'FAILURE', message: 'An error occurred while removing members' });
  }
});

export default router;