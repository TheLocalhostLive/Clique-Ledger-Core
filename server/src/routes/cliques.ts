import { Router, Request, Response } from 'express';
import {  PrismaClient } from '@prisma/client';
import { error } from 'console';
import checkAdmin from '../middlewares/checkAdmin';
import generateCliqueId from '../controllers/generateCliqueId';
import generateMemberId from '../controllers/generateMemberId';
import { auth } from 'express-oauth2-jwt-bearer';
import checkIdentity from '../middlewares/checkIdentity';

const prisma = new PrismaClient()

const router = Router();
const checkJwt = auth();

// get all cliques
router.get('/', async (req: Request, res: Response) => {
  try {
    const allRecords = await prisma.clique.findMany({
      include: {
        members: {
          include: {
            user: {
              select: {
                user_id: true,
                user_name: true
              }
            }
          }
        },
        transactions: {
          orderBy: {
            done_at: 'desc'
          },
          take: 1, // Get only the latest transaction
        }
      }
    });

    if (allRecords.length === 0) {
      console.log("No data");
      res.status(200).json("No data found");
      return;
    }

    const transformedRecords = allRecords.map(clique => ({
      clique_id: clique.clique_id,
      clique_name: clique.clique_name,
      admins: clique.members
        .filter(member => member.is_admin)
        .map(member => ({
          member_id: member.user_id,
          member_name: member.user.user_name
        })),
      members: clique.members.map(member => ({
        member_id: member.user_id,
        member_name: member.user.user_name
      })),
      is_fund: clique.is_fund,
      fund: clique.fund,
      isActive: clique.is_active,
      last_transaction: clique.transactions.length > 0 ? {
        transaction_id: clique.transactions[0].transaction_id,
        amount: clique.transactions[0].amount,
        description: clique.transactions[0].description,
        sender_id: clique.transactions[0].sender_id,
        done_at: clique.transactions[0].done_at,
      } : null
    }));

    res.status(200).json(transformedRecords);
  } catch (err) {
    console.log(err);
    res.status(500).json({ error: "An error occurred while fetching records" });
  }
});


// create a new clique and return
router.post('/', async (req: Request, res: Response) => {
  try {
    const name: string = req.body.name;
    const funds: number = parseFloat(req.body.funds);
    const fund_flag: boolean = funds !== 0;

    // Create new clique
    const newCliqueId = await generateCliqueId();
    const newClique = await prisma.clique.create({
      data: {
        clique_id: newCliqueId,
        fund: funds,
        is_fund: fund_flag,
        clique_name: name,
      },
      include: {
        members: {
          include: {
            user: {
              select: {
                user_id: true,
                user_name: true
              }
            }
          }
        }
      },
    });

    const transformedClique = {
      clique_id: newClique.clique_id,
      clique_name: newClique.clique_name,
      admins: newClique.members
        .filter(member => member.is_admin)
        .map(member => ({
          member_id: member.user_id,
          member_name: member.user.user_name
        })),
      members: newClique.members.map(member => ({
        member_id: member.user_id,
        member_name: member.user.user_name
      })),
      isFund: newClique.is_fund,
      fund: newClique.fund,
      isActive: newClique.is_active
    };

    res.status(201).json(transformedClique);
  } catch (err) {
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
        members: {
          include: {
            user: {
              select: {
                user_id: true,
                user_name: true
              }
            }
          }
        }
      },
    });

    if (!clique) {
      res.status(404).json({ message: 'Clique not found' });
      return;
    }

    const transformedClique = {
      clique_id: clique.clique_id,
      clique_name: clique.clique_name,
      admins: clique.members
        .filter(member => member.is_admin) // Filter admins
        .map(member => ({
          member_id: member.user_id,
          member_name: member.user.user_name
        })),
      members: clique.members.map(member => ({
        member_id: member.user_id,
        member_name: member.user.user_name
      })),
      isFund: clique.is_fund,
      fund: clique.fund,
      isActive: clique.is_active
    };

    res.status(200).json(transformedClique);
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
router.post('/:cliqueId/members/', checkAdmin, async (req: Request, res: Response) => {
  try {
    const cliqueId: string = req.params.cliqueId;
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
      // Fetch the user details to verify existence
      const user = await prisma.user.findUnique({
        where: { user_id: userId },
        select: { user_id: true, user_name: true }
      });

      if (user) {
        const newMemberId = await generateMemberId();

        // Create the new member
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

        newMembers.push({
          member_id: newMember.member_id,
          user_id: newMember.user_id,
          clique_id: newMember.clique_id,
          is_admin: newMember.is_admin,
          joined_at: newMember.joined_at,
          amount: newMember.amount,
          due: newMember.due,
          member_name: user.user_name
        });
      }
      else{
        res.status(404).json({
          status: 'FAILURE',
          message: `User with user_id ${userId} not found`,
        });
        return;
      }
    }

    if (newMembers.length === 0) {
      res.status(404).json({
        status: 'FAILURE',
        message: 'No valid users found to add to the clique.',
      });
      return;
    }

    res.status(201).json({
      status: 'SUCCESS',
      message: 'Members added successfully',
      data: newMembers,
    });
  } catch (err) {
    console.error(err);
    res.status(500).json({ status: 'FAILURE', message: 'An error occurred while adding members' });
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