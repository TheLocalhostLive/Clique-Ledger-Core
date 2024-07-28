import {  PrismaClient } from '@prisma/client';

const prisma = new PrismaClient()

  //generater a new member id
const generateMemberId = async()=> {
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

  export default generateMemberId;