import {  Router } from "express";
import type { CookieOptions } from "express";
import { signAccessToken, signRefreshToken, verifyToken } from "../lib/jwt.ts";
import { getAccessToken } from "../controllers/auth.ts";


const router = Router();

router.get("/new-access-token",getAccessToken)

export default router;