
import type { Request, Response, NextFunction } from "express";
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
    console.log(userinfojson)
    next();
  } catch(err) {
    console.log("Error");
    res.status(500).send("Soemthing went wrong");
  }
};
