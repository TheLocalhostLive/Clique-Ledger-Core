
import type { Request, Response, NextFunction } from "express";
import {  PrismaClient } from '@prisma/client';
import generateUserId from "../controllers/generateUserId";
const AUTH0_DOMAIN = 'dev-1yffugckd6d5gydc.us.auth0.com';


export default async function checkIdentity (req: Request, res: Response, next: NextFunction) {
  const token = req.headers.authorization && req.headers.authorization.split(' ')[1];
  if (!token) {
    res.status(401).send({ message: 'Authorization header missing or invalid' });
    return;
  }
  console.log(token);
  try {
    const userinfo = await fetch(`https://${AUTH0_DOMAIN}/userinfo`, {
      headers: {
        Authorization: `Bearer ${token}`
      }
    });
    const userinfojson = await userinfo.json();
    req.body.user = userinfojson;

    //This below code should be handled in Auth0 Post Login action
    //currently the API is not hosted and to test locally
    //we are doing it like this.

    //So here we are trying to save the user info in our database
    //when they are trying to login for the first time
    //IT IS DONE HERE LIKE THIS JUST FOR TESTING. 
    
    const prisma = new PrismaClient();
    if( typeof userinfojson === 'object' && 
      userinfojson !== null && "email" in userinfojson 
      && typeof userinfojson.email === "string" 
      && "name" in userinfojson
      && typeof userinfojson.name === "string"
    )  {
      const user = await prisma.user.findUnique({
        where: { user_id: userinfojson.email }
      });
      console.log(user);
      if(!user) {
        
        await prisma.user.create({data: {
          user_id: await generateUserId(),
          user_name: userinfojson.name,
          mail: userinfojson.email,
        }});

        console.log("`Created` success!!");
      }
    }
    next();
  } catch(err) {
    console.log("Error");
    res.status(500).send("Soemthing went wrong");
  }
};
