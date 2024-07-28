import {  PrismaClient } from '@prisma/client';

const prisma = new PrismaClient()

//generate a new clique id
const generateCliqueId = async()=> {
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

  export default generateCliqueId;