import * as z from 'zod';

export default async function getUserInfo(token: string) {
    const AUTH0_DOMAIN = 'dev-1yffugckd6d5gydc.us.auth0.com';
    if(!token) throw Error(`getUserInfo::No user token is provided token: ${token}`);
    const response = await fetch(`https://${AUTH0_DOMAIN}/userinfo`, {
      headers: {
        Authorization: `Bearer ${token}`
      }
    });
    const userInfo = await response.json();
    
    const UserInfoJsonSchema = z.object({
      name: z.string(),
      email: z.string(),
      phone: z.string().nullable().optional(),
      clique_ledger_app_uid: z.string()
    }).catchall(z.unknown());
    
    const parsedData = UserInfoJsonSchema.parse(userInfo);
    console.log('Validated Data:', parsedData);

    return parsedData;
  }
  
  