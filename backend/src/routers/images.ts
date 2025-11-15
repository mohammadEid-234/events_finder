import {  Router } from "express";
import type { RequestHandler } from "express";
import multer from "multer";
import { verifyToken } from "../lib/jwt.ts";
import User from "../models/User.ts";
const storage = multer.diskStorage({
    filename: (req, file, cb) => {
        //avoid duplicate file names
        const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1E9)
        cb(null,`img-${uniqueSuffix}.png` )
    },
    destination: "public/uploads/photos"
})
const uploads = multer({ storage: storage })

const router = Router()

const verifyUser : RequestHandler = (req,res,next)=>{

        try{
           const token= verifyToken(req.headers["access_token"]|| req.cookies["access_token"])
            req["user"]=token;
            next()
        }catch(e){
            console.error("error verifying token:",e)
             return res.status(401).send( "Expired or Invalid token" );
        }
    
}

router.post("/user/upload",verifyUser, uploads.single("uploaded_image"),async (req, res) => {
    try{
        console.log("user: ", req["user"])
        const userId = req['user'].user_id;
        const updateRes = await User.updateOne({_id: userId},{$set: {imgUrl: req.file.path}})
        console.log("update imgUrl result :",updateRes)
      
    return res.send("success").status(200)
    }catch(e){
        console.error("error uploading image:",e)
    }
   
})
export default router