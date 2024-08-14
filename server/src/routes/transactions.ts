import { Router, Request, Response } from 'express';
import { PrismaClient } from '@prisma/client';
import verifySender from "../middlewares/verifySender";
import generateTransactionId from '../controllers/generateTransactionId';
import { userSocketMap } from '../app';
import { Server as SocketIOServer } from 'socket.io';
import { auth } from 'express-oauth2-jwt-bearer';
import checkIdentity from '../middlewares/checkIdentity';
import checkCliqueLevelPerms from '../middlewares/checkCliqueLevelPerms';

const prisma = new PrismaClient();
const router = Router();
const checkJwt = auth();
// Get all transactions
// interface WhereClause {
//   sender_id?: string;
//   clique_id?: string;
//   AND?: Array<{ done_at?: Prisma.DateTimeFilter, spend?: { some: { member_id: string } } }>;
//   done_at?: Prisma.DateTimeFilter;
// }

const createTransactionRoute = (io: SocketIOServer) => {
  router.get('/', checkJwt, checkIdentity, checkCliqueLevelPerms("cliqueId", "member"), async (req: Request, res: Response) => {
    try {
      const { receiver, cliqueId, from_date, to_date } = req.query;
      const limit = 10;
      const offset = 2;

      // Construct the where condition
      const where: { [key: string]: any } = {};
      const memberId = req.body.member.member_id;
      if (memberId) {
        where.sender_id = memberId;
      }

      if (cliqueId) {
        where.clique_id = cliqueId;
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
  router.post('/', checkJwt, checkIdentity, checkCliqueLevelPerms("cliqueId", "member"), async (req: Request, res: Response) => {
    try {
      const { type, amount, description, cliqueId, participants } = req.body;

      // Create new transaction
      const newTransaction = await prisma.transaction.create({
        data: {
          transaction_id: await generateTransactionId(),
          transaction_type: type,
          sender_id: req.body.member.member_id,
          amount: parseFloat(amount),
          description: description,
          clique_id: cliqueId,
        },
      });

      // Create spend records and collect participant details
      const formattedParticipants = [];

      for (const participant of participants) {
        const receiverId = participant.id;
        const receiverAmount = parseFloat(participant.amount);

        const member = await prisma.member.findUnique({
          include: {
            user: true,
          },
          where: {
            member_id: receiverId,
            is_active: true,
          }
        });

        if (member) {
          await prisma.spend.create({
            data: {
              transaction_id: newTransaction.transaction_id,
              member_id: receiverId,
              amount: receiverAmount,
            },
          });
          
          formattedParticipants.push({
            member_id: member.member_id,
            member_name: member.user.user_name,
            part_amount: receiverAmount,
          });
        }
      }

      const senderMember = await prisma.member.findUnique({
        include: { user: true },
        where: { member_id: req.body.member.member_id },
      });

      // Broadcast the transaction to all members of the clique
      const cliqueMembers = await prisma.member.findMany({
        where: { clique_id: cliqueId },
        select: { user_id: true },
      });

      const transactionDetails = {
        transaction_id: newTransaction.transaction_id,
        clique_id: newTransaction.clique_id,
        is_verified: newTransaction.is_verified,
        done_at: newTransaction.done_at,
        description: newTransaction.description,
        transaction_type: newTransaction.transaction_type,
        sender: senderMember
          ? {
            member_id: senderMember.member_id,
            member_name: senderMember.user.user_name,
          }
          : null,
        participants: formattedParticipants,
        amount: newTransaction.amount,
      };

      cliqueMembers.forEach((member) => {
        const socketId = userSocketMap.get(member.user_id);
        if (socketId) {
          io.to(socketId).emit('newTransaction', transactionDetails);
        }
      });

      // Send the response
      res.status(201).json(transactionDetails);

    } catch (err) {
      console.error(err);
      res.status(500).json({ error: 'An error occurred when performing the transaction' });
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
        description: transaction.description,
        done_at: transaction.done_at,
        transaction_type: transaction.transaction_type,
        sender: {
          member_id: senderMember.member_id,
          member_name: senderMember.user.user_name
        },
        participants: participants,
        amount: transaction.amount
      };

      res.json(response);
    } catch (err) {
      console.error(err);
      res.status(500).json({ error: 'An error occurred while getting transaction details' });
    }
  });

  //delete a transaction
  router.delete('/:transactionId', async (req: Request, res: Response) => {
    try {
      const { transactionId } = req.params;

      // Fetch the transaction to get clique ID
      const transaction = await prisma.transaction.findUnique({
        where: { transaction_id: transactionId },
      });

      if (!transaction) {
        res.status(404).json({ error: 'Transaction not found' });
        return;
      }

      // Delete the transaction
      await prisma.transaction.delete({
        where: { transaction_id: transactionId },
      });

      // Notify members of the clique
      const cliqueMembers = await prisma.member.findMany({
        where: { clique_id: transaction.clique_id },
        select: { user_id: true },
      });

      cliqueMembers.forEach((member) => {
        const socketId = userSocketMap.get(member.user_id);
        if (socketId) {
          io.to(socketId).emit('transactionDeleted', {
            transaction_id: transactionId,
            clique_id: transaction.clique_id,
            message: 'A transaction has been deleted',
          });
        }
      });

      res.status(204).json({ message: 'Transaction deleted successfully' });
    } catch (err) {
      console.error(err);
      res.status(500).json({ error: 'An error occurred while deleting the transaction' });
    }
  });

  //accept transaction
  router.patch('/transaction/:transactionId/verify/accept', async (req: Request, res: Response) => {
    try {
      const { transactionId } = req.params;

      // Fetch and update the transaction
      const updatedTransaction = await prisma.transaction.update({
        where: { transaction_id: transactionId },
        data: { is_verified: "accepted" },
      });

      // Notify members of the clique
      const cliqueMembers = await prisma.member.findMany({
        where: { clique_id: updatedTransaction.clique_id },
        select: { user_id: true },
      });

      cliqueMembers.forEach((member) => {
        const socketId = userSocketMap.get(member.user_id);
        if (socketId) {
          io.to(socketId).emit('transactionUpdated', {
            transaction_id: transactionId,
            clique_id: updatedTransaction.clique_id,
            message: 'A transaction has been accepted',
          });
        }
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
    try {
      const { transactionId } = req.params;

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

      // Ensure the transaction type allows rejection
      if (transaction.transaction_type !== 'send') {
        res.status(400).json({
          status: 'FAILED',
          message: 'This type of transaction does not allow rejection',
        });
        return;
      }

      // Update the transaction status to "rejected"
      const updatedTransaction = await prisma.transaction.update({
        where: { transaction_id: transactionId },
        data: { is_verified: 'rejected' },
      });

      // Fetch members of the clique associated with the transaction
      const cliqueMembers = await prisma.member.findMany({
        where: { clique_id: transaction.clique_id },
        select: { user_id: true },
      });

      // Notify all members of the clique via WebSocket
      cliqueMembers.forEach((member) => {
        const socketId = userSocketMap.get(member.user_id);
        if (socketId) {
          io.to(socketId).emit('transactionUpdated', {
            transaction_id: transactionId,
            clique_id: transaction.clique_id,
            message: 'A transaction has been rejected',
            status: 'rejected',
          });
        }
      });

      // Send the response back to the client
      res.status(200).json({
        status: 'SUCCESS',
        message: 'Successfully rejected transaction',
        transaction: updatedTransaction,
      });
    } catch (error) {
      console.error(error);
      res.status(500).json({
        status: 'FAILED',
        message: 'An error occurred while rejecting the transaction',
      });
    }
  });

  // Add members to a spendable transaction
  router.post('/:transactionId/participants', verifySender, async (req: Request, res: Response) => {
    try {
      const transactionId = req.params.transactionId;
      const members = req.body;

      // Verify the transaction exists
      const transaction = await prisma.transaction.findUnique({
        where: { transaction_id: transactionId },
      });

      if (!transaction) {
        res.status(404).json({
          status: "FAILED",
          message: "Transaction not found",
        });
        return;
      }

      // Verify the transaction is valid for adding participants
      if (transaction.transaction_type !== 'send') {
        res.status(400).json({
          status: "FAILED",
          message: "This type of transaction does not allow participants",
        });
        return;
      }

      const cliqueId = transaction.clique_id;

      // Process each member
      for (const member of members) {
        const memberId = member.id;
        const amount = parseFloat(member.amount);

        // Validate the member exists and is part of the same clique
        const findMember = await prisma.member.findUnique({
          where: { member_id: memberId },
        });

        if (!findMember || findMember.clique_id !== cliqueId) {
          res.status(400).json({
            status: "FAILED",
            message: "One or more participant IDs are invalid or not in the same clique",
          });
          return;
        }

        // Add the member to the transaction
        await prisma.spend.create({
          data: {
            transaction_id: transactionId,
            member_id: memberId,
            amount: amount,
          },
        });
      }

      // Notify all members of the clique about the addition
      const cliqueMembers = await prisma.member.findMany({
        where: { clique_id: cliqueId },
        select: { user_id: true },
      });

      const notification = {
        transaction_id: transactionId,
        message: 'New participants have been added to a transaction',
      };

      cliqueMembers.forEach((member) => {
        const socketId = userSocketMap.get(member.user_id);
        if (socketId) {
          io.to(socketId).emit('transactionUpdated', notification);
        }
      });

      // Respond to the client
      res.status(204).json({
        status: "SUCCESS",
        message: "Participants added successfully",
      });

    } catch (err) {
      console.error(err);
      res.status(500).json({
        error: "An error occurred while adding participants to the transaction",
      });
    }
  });

  // Delete members from a spendable transaction
  router.delete('/:transactionId/participants', verifySender, async (req: Request, res: Response) => {
    try {
      const transactionId = req.params.transactionId;
      const membersToDelete = req.body; // Expecting an array of member IDs to delete

      // Verify the transaction exists
      const transaction = await prisma.transaction.findUnique({
        where: { transaction_id: transactionId },
      });

      if (!transaction) {
        res.status(404).json({
          status: "FAILED",
          message: "Transaction not found",
        });
        return;
      }

      const cliqueId = transaction.clique_id;

      // Validate and remove each member
      for (const memberId of membersToDelete) {
        // Check if the member is part of the transaction
        const spendRecord = await prisma.spend.findMany({
          where: {
            member_id: memberId,
            transaction_id: transactionId,
          },
        });

        if (spendRecord.length === 0) {
          res.status(400).json({
            status: "FAILED",
            message: "One or more participant IDs are invalid or not associated with this transaction",
          });
          return;
        }

        // Delete the member's spend record
        await prisma.spend.deleteMany({
          where: {
            member_id: memberId,
            transaction_id: transactionId,
          },
        });
      }

      // Notify all members of the clique about the removal
      const cliqueMembers = await prisma.member.findMany({
        where: { clique_id: cliqueId },
        select: { user_id: true },
      });

      const notification = {
        transaction_id: transactionId,
        message: 'Participants have been removed from a transaction',
      };

      cliqueMembers.forEach((member) => {
        const socketId = userSocketMap.get(member.user_id);
        if (socketId) {
          io.to(socketId).emit('transactionUpdated', notification);
        }
      });

      // Respond to the client
      res.status(204).json({
        status: "SUCCESS",
        message: "Participants removed successfully",
      });

    } catch (err) {
      console.error(err);
      res.status(500).json({
        error: "An error occurred while deleting participants from the transaction",
      });
    }
  });

  return router;
};

export default createTransactionRoute;