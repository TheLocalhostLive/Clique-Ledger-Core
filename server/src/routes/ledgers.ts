import { Router, Request, Response } from 'express';
import { PrismaClient } from '@prisma/client';
import { auth } from 'express-oauth2-jwt-bearer';

const prisma = new PrismaClient();
const router = Router();
const checkJwt = auth();

// Get a ledger of a clique
router.get('/clique/:cliqueId', checkJwt, async (req: Request, res: Response) => {
    try {
        const { cliqueId } = req.params;

        const newLedger = await prisma.ledger.findMany({
            include: {
                member: {
                    include: {
                        user: {
                            select: {
                                user_id: true,
                                user_name: true,
                                mail: true
                            }
                        }
                    }
                }
            },
            where: {
                clique_id: cliqueId
            }
        });

        if (newLedger.length === 0) {
            res.status(404).json({ error: 'No ledger found for this clique' });
            return;
        }

        const formattedLedger = newLedger.map(ledger => ({
            user_id: ledger.member.user.user_id,
            user_name: ledger.member.user.user_name,
            mail: ledger.member.user.mail,
            member_id: ledger.member_id,
            amount: Math.abs(ledger.amount),
            is_due: ledger.is_due,
            clique_id: ledger.clique_id
        }));

        res.json(formattedLedger);
    } catch (err) {
        console.error(err);
        res.status(500).json({ message: "An error occurred while fetching the ledger" });
    }
});

//get ledger of a member
router.get('/clique/:cliqueId/member/:memberId', checkJwt, async (req: Request, res: Response) => {
    try {
        const { cliqueId, memberId } = req.params;

        const transactions = await prisma.transaction.findMany({
            where: {
                clique_id: cliqueId,
                OR: [
                    { sender_id: memberId },
                    { spend: { some: { member_id: memberId }}}
                ]
            },
            include: {
                spend: true
            }
        });

        const formattedTransactions = transactions.map(transaction => {
            let sendAmount = null;
            let receiveAmount = null;

            if (transaction.sender_id == memberId) {
                sendAmount = transaction.amount;
            }

            // Check if the member is involved in the spend
            const spendDetail = transaction.spend.find(spend => spend.member_id == memberId);

            if (spendDetail) {
                receiveAmount = spendDetail.amount;
            }

            return {
                transaction_id: transaction.transaction_id,
                date: transaction.done_at,
                description: transaction.description,
                send_amount: sendAmount,
                receive_amount: receiveAmount
            };
        });

        res.json(formattedTransactions);
    } catch (err) {
        console.error(err);
        res.status(500).json({ message: "An error occurred while fetching the transactions" });
    }
});


export default router;
