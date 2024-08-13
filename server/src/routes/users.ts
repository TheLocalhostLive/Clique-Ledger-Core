import { Router, Request, Response } from 'express';
import {  PrismaClient } from '@prisma/client';
import generateUserId from '../controllers/generateUserId';

const prisma = new PrismaClient()

const router = Router();


//get all users
router.get('/', async (req: Request, res: Response) => {
    try {
        const users = await prisma.user.findMany();
        const userArray = [];
        for(const user of users) {
            userArray.push({
                id: user.user_id,
                name: user.user_name,
                phone: user.phone_no,
                email: user.mail
            });
        }
        res.json(userArray);
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'An error occurred while fetching users' });
    }
});

//create a new user
router.post('/', async (req: Request, res: Response) => {
    try {
        const { name, phone, email } = req.body;
    
        const user = await prisma.user.create({
            data: {
                user_id: await generateUserId(),
                user_name: name,
                mail: email,
                phone_no: phone
            }
        });
        res.status(201).json({
            id: user.user_id,
            name: user.user_name,
            phone: user.phone_no,
            email: user.mail
        });
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'An error occurred while creating user' });
    }
});

//get user by id
router.get('/:userId', async(res: Response, req: Request) => {
    try{
        const userId = req.params.userId;
        const user = await prisma.user.findUnique({
            where: { user_id: userId }
        });
        if(!user){
            res.status(404).json({ status: 'NOT FOUND' });
            return;
        }
        res.json({
            staus: "SUCCESS",
            data:{
                id: user.user_id,
                name: user.user_name,
                phone: user.phone_no,
                email: user.mail
            }
        });
    } catch(err){
        console.error(err);
        res.status(500).json({ error: 'An error occurred while fetching user' });
    }
});

//update user by id
router.patch('/:userId', async(req: Request, res: Response) =>{
    try{
         const { userName, email, phone } = req.body;
         const userId = req.params.userId;
         const getUser = await prisma.user.findUnique({
            where:{user_id: userId}
         })
         if(!getUser){
            res.status(404).json({ status: "FAILED", error: 'User not found'});
            return;
         }
         if(userName){
            await prisma.user.update({
                where: {user_id: userId},
                data:
                {
                    user_name: userName
                }
            });
         }
         if(email){
            const checkMail = await prisma.user.findUnique({ 
                where: {mail: email}
            });

            if(checkMail){
                res.status(400).json({status: "FAILED", message: "This email already linked to different a user"});
                return;
            }
            await prisma.user.update({
                where: {user_id: userId},
                data:
                {
                    mail: email
                }
            });
         }
         if(phone){
            const checkPhone = await prisma.user.findFirst({ 
                where: {phone_no: phone}
            });

            if(checkPhone){
                res.status(400).json({status: "FAILED", message: "This phone number already linked to different an user"});
                return;
            }
            await prisma.user.update({
                where: {user_id: userId},
                data:
                {
                    phone_no: phone
                }
            }); 
         }
         res.status(204).json({message: "Successfully updated user"});
    }
    catch(err){
        console.log(err);
        res.status(500).json({error: "An error occurred while updating user"});
    }
});

//delete an user
router.delete('/:userId', async (req: Request, res: Response) => {
    try {
        const userId = req.params.userId;
        const findUser = await prisma.user.findUnique({
            where: {
                user_id: userId
            },
        });
        if(!findUser){
            res.status(404).json({
                status: "FAILED",
                error: "User not found"
            });
            return;
        }
        await prisma.user.delete({
            where:{
                user_id: userId
            }
        });
        res.status(204).send();
    }
    catch(err){
        console.log(err);
        res.status(500).json({
            status: "INTERNAL SERVER ERROR",
            message: "Please try later!"
        })
    }
});

export default router;