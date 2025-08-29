import { Router } from "express";

import { createUser } from "../controllers/usersController.ts";
const router =  Router()

router.post("/",createUser)
export default router;