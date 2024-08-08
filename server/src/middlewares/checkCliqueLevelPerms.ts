import { Request, Response, NextFunction } from 'express';
import { PrismaClient } from '@prisma/client';


type CliquePermissionName = 'admin' | 'member';

/**
 * Middleware function to check clique level permission of an user i.e. 'admin' or 'member' 
 * 
 * @param cliqueInfo - A string that specifies the parameter name in the request object that contains the clique ID. 
 * It can start with ':/', '?' to indicate different sources of the parameter.
 * @param permissionName - The name of the permission to check, typically 'admin' or 'member.
 * 
 * @returns Express middleware function that checks user permissions and proceeds to the next middleware if authorized.
 * 
 * @example
 * // In an Express route
 * app.use('/clique/:cliqueId', checkCliqueLevelPerms(':/cliqueId', 'admin'), (req, res) => {
 *   res.send('You are an admin of the clique');
 * });
 */

export default function checkCliqueLevelPerms(
    cliqueInfo: string,
    permissionName: CliquePermissionName
  ) {
    let cliqueParamName: string;
    const prisma = new PrismaClient();
  
    if (cliqueInfo.startsWith(':/')) {
      cliqueParamName = cliqueInfo.slice(2);
    } else if (cliqueInfo.startsWith('?')) {
      cliqueParamName = cliqueInfo.slice(1);
    }
  
    // This is the actual middleware
    return (req: Request, res: Response, next: NextFunction) => {
      const cliqueId = req.params[cliqueParamName];
      const userId = req.body.user['https://cliqueledger.com/uid'] as string;
      const userInfo = prisma.member.findFirst({
        where: {
          clique_id: cliqueId,
          user_id: userId,
          is_admin: permissionName === 'admin',
        },
      });
  
      if (!userInfo) {
        res.status(403).json({
          message: `You must be a ${permissionName} of the group to perform the operation.`,
        });
        return;
      }
      next();
    };
  }
  