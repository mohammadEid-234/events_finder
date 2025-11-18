import { Router } from "express";
import type { RequestHandler } from "express";
import multer from "multer";
import { verifyToken } from "../lib/jwt.ts";
import User from "../models/User.ts";
import { uploadImg } from "../controllers/images.ts";
import { verifyUser } from "../controllers/auth.ts";
const storage = multer.diskStorage({
    filename: (req, file, cb) => {
        //avoid duplicate file names
        console.log("file:", file)
        const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1E9)
        cb(null, `img-${uniqueSuffix}.png`)
    },
    destination: "public/uploads/photos"
})
const uploads = multer({ storage: storage })

const router = Router()



router.post("/upload", verifyUser, uploads.single("uploaded_image"),uploadImg)
export default router