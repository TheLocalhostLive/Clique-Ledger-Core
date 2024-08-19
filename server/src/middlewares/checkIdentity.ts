
import type { Request, Response, NextFunction } from "express";
import * as z from 'zod';
import getUserInfo from "../controllers/getUserInfo";

export default async function checkIdentity (req: Request, res: Response, next: NextFunction) {
  const token = req.headers.authorization && req.headers.authorization.split(' ')[1];
  if (!token) {
    res.status(401).send({ message: 'Authorization header missing or invalid' });
    return;
  }
  try{
    const userInfojson = await getUserInfo(token);
    
    const user = {
      user_name: userInfojson.name,
      user_email: userInfojson.email,
      user_id: userInfojson.clique_ledger_app_uid,
      user_phone: userInfojson.phone
    }

    req.body.user = user;
    console.log(userInfojson);
    next();
  } catch(err) {
    console.log("Error");
    res.status(500).send("Soemthing went wrong");
  }
};
