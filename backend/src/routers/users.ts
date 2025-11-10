import { Router } from "express";

import { createUser } from "../controllers/usersController.ts";
import multer from "multer";
const router =  Router()
const uploads = multer({dest: "uploads/photos"})

router.post("/",createUser)
export default router;