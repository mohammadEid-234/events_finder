import { Router } from "express";
import { signAccessToken, signRefreshToken, verifyToken } from "../lib/jwt.ts";

const router = Router();

router.get("/refresh-token", (req, res) => {
    const sentToken = req.header("refreshToken");
    console.log("sentRefreshToken:",sentToken);
    try {
        const verifiedRefreshToken = verifyToken(sentToken)
        res.cookie("refreshToken",verifiedRefreshToken);
        return res.status(200).send({
            "accessToken": signAccessToken({"user_id":verifiedRefreshToken["user_id"]})});
    } catch (e) {
        console.log("refresh token catch:", e)
        return res.status(401).send({ "message": "Expired or Invalid refresh token" });
    }

    

})

export default router;