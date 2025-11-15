import { Router } from "express";
import { signAccessToken, signRefreshToken, verifyToken } from "../lib/jwt.ts";

const router = Router();

router.get("/refresh-token", (req, res) => {
    console.log("request cookies",req.cookies)
    const sentToken = req.header("refresh_token") || req.cookies["refresh_token"];
    console.log("sentRefreshToken:",sentToken);
    try {
        const verifiedRefreshToken = verifyToken(sentToken)
        res.cookie("refresh_token",verifiedRefreshToken);
        return res.status(200).send({
            "access_token": signAccessToken({"user_id":verifiedRefreshToken["user_id"]})});
    } catch (e) {
        console.log("refresh token catch:", e)
        return res.status(401).send({ "message": "Expired or Invalid refresh token" });
    }

    

})

export default router;