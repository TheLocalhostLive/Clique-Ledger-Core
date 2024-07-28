import {  PrismaClient } from '@prisma/client';

const prisma = new PrismaClient()

//create a new transaction id
const generateTransactionId = async() => {
    const latestTransaction = await prisma.transaction.findFirst({
      orderBy: { transaction_id: 'desc' },
    });
  
    let newId;
    if (latestTransaction) {
      const latestIdNumber = parseInt(latestTransaction.transaction_id.slice(1));
      newId = `T${(latestIdNumber + 1).toString().padStart(9, '0')}`;
    } else {
      newId = 'T000000001';
    }
  
    return newId;
  }

  export default generateTransactionId;