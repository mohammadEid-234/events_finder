import type { RequestHandler,CookieOptions } from "express";
import { signAccessToken, verifyToken } from "../lib/jwt.ts";
export const globalCookieOptions: CookieOptions = {
    httpOnly: true,        // not accessible via JS
    secure: true,          // only sent over HTTPS
    sameSite: "strict",    // CSRF protection
}
export const refreshTokenOptions: CookieOptions = {
    ...globalCookieOptions,
    maxAge: 7 * 24 * 60 * 60 * 1000, // valid for 7 days
}
export const accessTokenOptions: CookieOptions = {
    ...globalCookieOptions,
    maxAge: 15 * 60 * 1000, // valid for 15 minutes
}

export const verifyUser: RequestHandler = (req, res, next) => {

    try {
        const token = verifyToken(req.headers["access_token"] || req.cookies["access_token"])

        req["user_id"] = token["user_id"];
        next()
    } catch (e) {
        console.error("error verifying token:", e)
        return res.status(401).send("Expired or Invalid token");
    }

}

export const getAccessToken:RequestHandler = async (req,res)=>{
        console.log("request cookies", req.cookies)
    const sentToken = req.header("refresh_token") || req.cookies["refresh_token"];
    console.log("sentRefreshToken:", sentToken);
    try {
        const verifiedRefreshToken = verifyToken(sentToken)
        const newAccessToken = signAccessToken({ "user_id": verifiedRefreshToken["user_id"] })
        res.cookie("access_token", newAccessToken, accessTokenOptions)
        res.cookie("refresh_token", verifiedRefreshToken, refreshTokenOptions);
        return res.status(200).send({
            "access_token": newAccessToken
        });
    } catch (e) {
        console.log("refresh token catch:", e)
        return res.status(401).send({ "message": "Expired or Invalid refresh token" });
    }


}