import type { RequestHandler } from "express";
import Joi from "joi";
import { parsePhoneNumberWithError } from "libphonenumber-js";
import User from "../models/User.ts";
import bcrypt from "bcryptjs";
import { signAccessToken, signRefreshToken } from "../lib/jwt.ts";


export const createUser: RequestHandler = async (req, res,next) => {
    try {
        if (!req.body) return res.status(400).send({ "message": "Invalid json" });
        const paramsSchema = Joi.object({
            full_name: Joi.string().required().trim().not().empty().min(2).pattern(/^[\p{L}\p{M}\s'.-]+$/u),
            phone_number: Joi.string(),
            email: Joi.string().email(),
            //require at least 1 lowercase, 1 uppercase, 1 number, 1 special char, 8–20 length
            password: Joi.string().required().pattern(new RegExp(/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^A-Za-z\d])[A-Za-z\d\S]{8,20}$/)),
        })
            //one of phone_number and email is required but not together 
            .xor("phone_number", "email")

        const { error, value: params } = paramsSchema.validate(req.body, { errors: { wrap: { label: "" } } })
        if (error) return res.status(400).send({ "message": error.message });
        let validPhoneNumber;
        if (params.phone_number) {

            try {
                const checkPhoneRes = parsePhoneNumberWithError(params.phone_number, { extract: true })
                console.log("checkPhoneNumber result:", checkPhoneRes)
                if (!checkPhoneRes.isValid()) {
                    return res.status(400).send({ "message": "Invalid phone number" })
                }
                validPhoneNumber = checkPhoneRes.number;
            } catch (e) {
                console.log("error validating phone number:", e)
                return res.status(500).send({"message":"error validating phone number"})
            }

        }
        const query = validPhoneNumber ? { phoneNumber: validPhoneNumber } : { email: params.email }
        const userExists = await User.findOne(query);
        if (userExists) return res.status(400).send({ "message": "There exists a user with same phone_number/email" })

        //generate hashed password    
        const passwordSalt = await bcrypt.genSalt(10)
        const passwordHashed = await bcrypt.hash(params.password, passwordSalt);

        const user = await User.create({
            email: params.email,
            phoneNumber: validPhoneNumber,
            fullName: params.full_name,
            password: passwordHashed
        })

        //store the refresh token in the cookies
        res.cookie("refresh_token", signRefreshToken({ "user_id": user.id }), {
            httpOnly: true,        // not accessible via JS
            secure: true,          // only sent over HTTPS
            sameSite: "strict",    // CSRF protection
            maxAge: 7 * 24 * 60 * 60 * 1000, // 7 days
        });
        return res.status(201).send({
            "access_token": signAccessToken({ "user_id": user.id }),
            "message": "success"
        })
    } catch (e) {
        console.error("createUser error:", e)
        res.status(500).json({ "message": "Internal Server Error" })
    }


}
