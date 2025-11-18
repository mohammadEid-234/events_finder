import { Router } from "express";

import { createUser, signIn, signOut } from "../controllers/users.ts";
const router =  Router()

router.post("/sign-up",createUser)
router.post("/sign-in",signIn)
router.post("/sign-out",signOut)

//TODO: sign in and sign out
export default router;