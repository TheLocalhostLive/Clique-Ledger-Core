/**NOTE: THIS IS UNSAFE AND SHOULD BE HANDLED IN DATABASE LEVEL
 * Doing it this way may create RACE CONDITION in case
 * of concurrent requests. 
 * SHOULD BE CHANGED AS EARLY AS POSSIBLE
 */


import {  PrismaClient } from '@prisma/client';

const prisma = new PrismaClient()

//create a new media id
const generateMediaId = async() => {
    const latestMedia = await prisma.media.findFirst({
      orderBy: { media_id: 'desc' },
    });
  
    let newId;
    if (latestMedia) {
      const latestIdNumber = parseInt(latestMedia.media_id.slice(3));
      newId = `MED${(latestIdNumber + 1).toString().padStart(9, '0')}`;
    } else {
      newId = 'MED000000001';
    }
  
    return newId;
  }

  export default generateMediaId;