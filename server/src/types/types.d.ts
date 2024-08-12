
import { JwtPayload } from 'jsonwebtoken';

export interface Auth0User extends JwtPayload {
  sub: string;
  [key: string]: string | number | undefined | string[]; 
}


declare module 'express-serve-static-core' {
  interface Request {
    user?: Auth0User;
  }
}
