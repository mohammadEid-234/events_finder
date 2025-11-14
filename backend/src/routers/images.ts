import {  Router } from "express";
import type { RequestHandler } from "express";
import multer from "multer";
import { verifyToken } from "../lib/jwt.ts";
const storage = multer.diskStorage({
    filename: (req, file, cb) => {
        
        const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1E9)
        cb(null,`img-${uniqueSuffix}.png` )
    },
    destination: "public/uploads/photos"
})
const uploads = multer({ storage: storage })

const router = Router()

const imagesMiddleware : RequestHandler = (req,res,next)=>{

        try{
           const token= verifyToken(req.headers["access_token"])
            req["user"]=token;
            next()
        }catch(e){
            console.error("error verifying token:",e)
             return res.status(401).send( "Expired or Invalid token" );
        }
    
}

router.post("/upload",imagesMiddleware, uploads.single("uploaded_image"),(req, res) => {
    try{
        console.log("user: ", req["user"])
      
    return res.send("success").status(200)
    }catch(e){
        console.error("error uploading image:",e)
    }
   
})
export default router