import {  PrismaClient } from '@prisma/client';

const prisma = new PrismaClient()

//generate user id
const generateUserId = async () => {
    const latestUser = await prisma.user.findFirst({
      orderBy: { user_id: 'desc' },
    });
  
    let newId;
    if (latestUser) {
      const latestIdNumber = parseInt(latestUser.user_id.slice(1));
      newId = `U${(latestIdNumber + 1).toString().padStart(6, '0')}`;
    } else {
      newId = 'U000001';
    }
  
    return newId;
  }

  export default generateUserId;