
import type { Request, Response, NextFunction } from "express";
import * as z from 'zod';

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
    
    const UserInfoJsonSchema = z.object({
      name: z.string(),
      email: z.string(),
      phone: z.string().nullable().optional(),
      clique_ledger_app_uid: z.string()
    }).catchall(z.unknown());
    
    const parsedData = UserInfoJsonSchema.parse(userinfojson);
    console.log('Validated Data:', parsedData);

    const user = {
      user_name: parsedData.name,
      user_email: parsedData.email,
      user_id: parsedData.clique_ledger_app_uid,
      user_phone: parsedData.phone
    }

    req.body.user = user;
    console.log(userinfojson)
    next();
  } catch(err) {
    console.log("Error");
    res.status(500).send("Soemthing went wrong");
  }
};
