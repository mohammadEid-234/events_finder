import { Router } from "express";
import type { RequestHandler } from "express";
import multer from "multer";
import { verifyToken } from "../lib/jwt.ts";
import User from "../models/User.ts";
import { uploadImg } from "../controllers/images.ts";
import { verifyUser } from "../controllers/auth.ts";
import "dotenv/config"; // auto-loads .env

const storage = multer.diskStorage({
    filename: (req, file, cb) => {
        //avoid duplicate file names
        console.log("file:", file)
        const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1E9)
        cb(null, `img-${uniqueSuffix}.png`)
    },
    destination: process.env.IMAGES_PATH || "public/uploads/photos"
})
const uploads = multer({ storage: storage })

const router = Router()



router.post("/profile", verifyUser, uploads.single("uploaded_image"),uploadImg)
export default router