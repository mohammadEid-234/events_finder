import { Router } from "express";

import { createUser, signIn, signOut } from "../controllers/users.ts";
import { verifyUser } from "../controllers/auth.ts";
const router =  Router()

router.post("/sign-up",createUser)
router.post("/sign-in",signIn)
//sign-out requires a valid user 
router.post("/sign-out",verifyUser,signOut)

//TODO: sign in and sign out
export default router;