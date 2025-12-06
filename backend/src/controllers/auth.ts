import type { RequestHandler, CookieOptions } from "express";
import { accessTokenSignOptions, refreshTokenSignOptions, signAccessToken, verifyToken } from "../lib/jwt.ts";
import jwt from "jsonwebtoken";
import { v4 as uui } from "uuid";
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
        const bearerToken = req.headers["authorization"].split(" ")[1];
        const token = verifyToken(bearerToken || req.cookies["access_token"])

        req["user_id"] = token["user_id"];
        next()
    } catch (e) {
        console.error("error verifying token:", e)
        return res.status(401).send({ "message": "Expired or Invalid token" });
    }

}

export const getAccessToken: RequestHandler = async (req, res) => {

    const sentToken = req.header("refresh_token") || req.cookies["refresh_token"];
    try {
        const verifiedRefreshToken = verifyToken(sentToken)
        console.log("verified refresh token:", verifiedRefreshToken);
        const oldExp = verifiedRefreshToken["exp"]; // absolute timestamp from old token
        const nowInSeconds = Math.floor(Date.now() / 1000);
        const remainingSeconds = oldExp - nowInSeconds; // avoid extending expiry on refresh
        console.log("remaining seconds for refresh token:", remainingSeconds);
        if (remainingSeconds <= 0) {
            return res.status(401).send({ "message": "Expired refresh token" });
        }
        const newAccessToken = signAccessToken({ "user_id": verifiedRefreshToken["user_id"], })
        const newRefreshToken = jwt.sign({ "user_id": verifiedRefreshToken["user_id"],/*unique Id for each token*/"uuid": uui() }, process.env.JWT_SECRET ?? "", {
             ...refreshTokenSignOptions,
            expiresIn: remainingSeconds // set refresh token expiry same as old one
        });
        res.cookie("access_token", newAccessToken, accessTokenOptions)
        res.cookie("refresh_token", newRefreshToken, refreshTokenOptions);
        return res.status(200).send({
            "refresh_token": newRefreshToken,
            "access_token": newAccessToken
        });
    } catch (e) {
        console.log("refresh token catch:", e)
        return res.status(401).send({ "message": "Expired or Invalid refresh token" });
    }


}