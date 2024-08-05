import { Router, Request, Response } from 'express';
import { PrismaClient, Prisma } from '@prisma/client';
import verifySender from "../middlewares/verifySender";
import generateTransactionId from '../controllers/generateTransactionId';

const prisma = new PrismaClient();
const router = Router();


// Get all transactions
// interface WhereClause {
//   sender_id?: string;
//   clique_id?: string;
//   AND?: Array<{ done_at?: Prisma.DateTimeFilter, spend?: { some: { member_id: string } } }>;
//   done_at?: Prisma.DateTimeFilter;
// }
router.get('/', async (req: Request, res: Response) => {
  try {
    const { sender, receiver, clique, from_date, to_date } = req.query;
    const limit = 10;
    const offset = 2;

    // Construct the where condition
    const where: { [key: string]: any } = {};

    if (sender) {
      where.sender_id = sender;
    }

    if (clique) {
      where.clique_id = clique;
    }

    if (from_date || to_date) {
      if (!where.AND) {
        where.AND = [];
      }

      const dateFilter: { [key: string]: Date } = {};

      if (from_date && typeof from_date === 'string') {
        dateFilter.gte = new Date(from_date);
      }

      if (to_date && typeof to_date === 'string') {
        dateFilter.lte = new Date(to_date);
      }

      where.AND.push({ done_at: dateFilter });
    }

    if (receiver) {
      if (!where.AND) {
        where.AND = [];
      }

      where.AND.push({
        spend: {
          some: {
            member_id: receiver
          }
        }
      });
    }

    const transactions = await prisma.transaction.findMany({
      where: where,
      take: limit,
      skip: offset,
      include: {
        spend: {
          include: {
            member: {
              include: {
                user: true
              }
            }
          }
        },
        sender: {
          include: {
            user: true
          }
        }
      }
    });

    const formattedTransactions = transactions.map(transaction => ({
      transaction_id: transaction.transaction_id,
      amount: transaction.amount,
      description: transaction.description,
      sender: {
        member_id: transaction.sender.member_id,
        member_name: transaction.sender.user.user_name
      },
      clique_id: transaction.clique_id,
      transaction_type: transaction.transaction_type,
      is_verified: transaction.is_verified,
      done_at: transaction.done_at,
      participants: transaction.spend.map(spend => ({
        member_id: spend.member.member_id,
        member_name: spend.member.user.user_name,
        part_amount: spend.amount
      }))
    }));

    res.json(formattedTransactions);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Server Error' });
  }
});

//to create a new transaction
interface Participant {
  id: string;
  amount: string;
}
router.post('/', async (req: Request, res: Response) => {
  try {
    const type = req.body.type;
    const sender = req.body.sender;
    const amount = parseFloat(req.body.amount);
    const des = req.body.description;
    const cliqueId = req.body.cliqueId;
    
    // Create new transaction
    const newTransaction = await prisma.transaction.create({
      data: {
        transaction_id: await generateTransactionId(),
        transaction_type: type,
        sender_id: sender,
        amount: amount,
        description: des,
        clique_id: cliqueId
      }
    });

    // Create spend records and collect participant details
    const participants: Participant[] = req.body.participants;
    const formattedParticipants = [];
    for (const participant of participants) {
      const receiverId = participant.id;
      const receiverAmount = parseFloat(participant.amount);

      await prisma.spend.create({
        data: {
          transaction_id: newTransaction.transaction_id,
          member_id: receiverId,
          amount: receiverAmount
        }
      });

      const member = await prisma.member.findUnique({
        where: { member_id: receiverId },
        include: { user: true }
      });

      if (member) {
        formattedParticipants.push({
          member_id: member.member_id,
          member_name: member.user.user_name,
          part_amount: receiverAmount
        });
      }
    }

    const senderMember = await prisma.member.findUnique({
      where: { member_id: sender },
      include: { user: true }
    });

    // Send the response
    res.status(201).json({
      transaction_id: newTransaction.transaction_id,
      clique_id: newTransaction.clique_id,
      type: newTransaction.transaction_type,
      sender: senderMember
        ? {
            member_id: senderMember.member_id,
            member_name: senderMember.user.user_name
          }
        : null,
      participants: formattedParticipants,
      spend_amount: newTransaction.amount
    });

  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'An error occurred when performing transaction' });
  }
});

//get a specific transaction
router.get('/:transactionId', async (req: Request, res: Response) => {
  try {
    const transactionId = req.params.transactionId;

    // Fetch the transaction
    const transaction = await prisma.transaction.findUnique({
      where: { transaction_id: transactionId }
    });

    if (!transaction) {
      res.status(404).json({ error: 'Transaction not found' });
      return;
    }

    // Fetch the sender member details
    const senderMember = await prisma.member.findUnique({
      where: { member_id: transaction.sender_id },
      include: { user: true } // Fetch associated user details from the Member table
    });

    if (!senderMember) {
      res.status(404).json({ error: 'Sender member not found' });
      return;
    }

    // Fetch the participants
    const receivers = await prisma.spend.findMany({
      where: { transaction_id: transactionId },
      include: {
        member: {
          include: {
            user: true // Include user details for participants
          }
        }
      }
    });

    // Format participants
    const participants = receivers.map(receiver => ({
      member_id: receiver.member.member_id,
      member_name: receiver.member.user.user_name,
      part_amount: receiver.amount
    }));

    // Prepare the response
    const response = {
      transaction_id: transaction.transaction_id,
      clique_id: transaction.clique_id,
      type: transaction.transaction_type,
      sender: {
        member_id: senderMember.member_id,
        member_name: senderMember.user.user_name
      },
      participants: participants,
      spend_amount: transaction.amount
    };

    res.json(response);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'An error occurred while getting transaction details' });
  }
});

//accept transaction
router.patch('/transaction/:transactionId/verify/accept', async (req: Request, res: Response) => {
  const { transactionId } = req.params;

  try {
    // Fetch the transaction by ID
    const transaction = await prisma.transaction.findUnique({
      where: { transaction_id: transactionId },
    });

    // Check if the transaction exists
    if (!transaction) {
      res.status(404).json({
        status: 'FAILED',
        message: 'Transaction not found',
      });
      return;
    }

    if (transaction.transaction_type !== 'send') {
      res.status(400).json({
        status: 'FAILED',
        message: 'This type of transaction does not allow such action',
      });
      return;
    }
    const updatedTransaction = await prisma.transaction.update({
      where: { transaction_id: transactionId },
      data: { is_verified: "accepted" },
    });

    res.status(200).json({
      status: 'SUCCESS',
      message: 'Successfully verified transaction',
      transaction: updatedTransaction,
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({
      status: 'FAILED',
      message: 'An error occurred while verifying the transaction',
    });
  }
});

//reject transaction
router.patch('/transaction/:transactionId/verify/reject', async (req: Request, res: Response) => {
  const { transactionId } = req.params;

  try {
    // Fetch the transaction by ID
    const transaction = await prisma.transaction.findUnique({
      where: { transaction_id: transactionId },
    });

    // Check if the transaction exists
    if (!transaction) {
      res.status(404).json({
        status: 'FAILED',
        message: 'Transaction not found',
      });
      return;
    }

    if (transaction.transaction_type !== 'send') {
      res.status(400).json({
        status: 'FAILED',
        message: 'This type of transaction does not allow such action',
      });
      return;
    }
    const updatedTransaction = await prisma.transaction.update({
      where: { transaction_id: transactionId },
      data: { is_verified: "rejected" },
    });

    res.status(200).json({
      status: 'SUCCESS',
      message: 'Successfully rejected transaction',
      transaction: updatedTransaction,
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({
      status: 'FAILED',
      message: 'An error occurred while verifying the transaction',
    });
  }
});

//add members to a spendable transaction
router.post('/:transactionId/participants', verifySender, async (req: Request, res: Response) => {
  try {
    const transactionId = req.params.transactionId;
    const checkTransaction = await prisma.transaction.findUnique({
      where: { transaction_id: transactionId },
    });
    if (!checkTransaction) {
      res.status(404).json({
        status: "FAILED",
        message: "Transaction id is provided wrong"
      });
    }
    const cliqueId = checkTransaction?.clique_id;
    const members = req.body;
    for (const member of members) {
      const memberId = member.id;
      const findMember = await prisma.member.findUnique({
        where: {
          member_id: memberId
        }
      });
      if(!findMember || findMember.clique_id != cliqueId ){
        res.status(400).json({
          status: "FAILED",
          message: "One or more participant id is provided wrong"
        });
      }
      const newAmount = parseFloat(member.amount);
      await prisma.spend.create({
        data: {
          transaction_id: transactionId,
          member_id: memberId,
          amount: newAmount,
        }
      });
    }
    res.status(204).json({
      status: "SUCCESS",
      message: "Members added successfully"
    })
  } catch (err) {
    console.log(err);
    res.status(500).json({
      error: "An error occured while adding members to a transaction"
    });
  }
});

//delte member from spend
router.delete("./:transaction_id/participants", verifySender, async (req: Request, res: Response) => {
  try{
    const transactionId = req.params.transactionId;
    const checkTransaction = await prisma.transaction.findUnique({
      where: { transaction_id: transactionId },
    });
    if (!checkTransaction) {
      res.status(404).json({
        status: "FAILED",
        message: "Transaction id is provided wrong"
      });
    }
    const members = req.body;
    for(const memberId of members) {
      const findMember = await prisma.spend.findMany({
        where:{
          member_id: memberId,
          transaction_id: transactionId
        }
      });
      if(!findMember) {
        res.status(400).json({
          "status": "FAILED",
          "message": "One or more participant id is provided wrong"
        });
        return;
      }
      await prisma.spend.deleteMany({
        where:{
          member_id: memberId,
          transaction_id: transactionId
        }
      })
    }
  } catch(err){
    console.log(err);
    res.status(500).json({error: "An error occured while deleting members from a transaction"});
  }
});

export default router;