import type { CookieOptions, RequestHandler } from "express";
import Joi from "joi";
import { parsePhoneNumberWithError } from "libphonenumber-js";
import User from "../models/User.ts";
import bcrypt from "bcryptjs";
import { signAccessToken, signRefreshToken } from "../lib/jwt.ts";
import { accessTokenOptions, globalCookieOptions, refreshTokenOptions } from "../controllers/auth.ts";


export const createUser: RequestHandler = async (req, res, next) => {
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
                return res.status(500).send({ "message": "error validating phone number" })
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
        const refreshToken = signRefreshToken({ "user_id": user.id })
        const accessToken = signAccessToken({ "user_id": user.id })

        //store the refresh and access tokens in the cookies for browsers (more secure than local-storage)
        res.cookie("refresh_token", refreshToken, refreshTokenOptions);
        res.cookie("access_token", accessToken, accessTokenOptions);
        return res.status(201).send({
            "access_token": accessToken,
            "refresh_token": refreshToken,
            "message": "User created successfully "
        })
    } catch (e) {
        console.error("createUser error:", e)
        res.status(500).json({ "message": "Internal Server Error" })
    }


}
export const signIn: RequestHandler = async (req, res, next) => {
    try {
        if (!req.body) return res.status(400).send({ "message": "Invalid json" });
        const paramsSchema = Joi.object({
            phone_number: Joi.string(),
            email: Joi.string().email(),
            password: Joi.string().required()
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
                return res.status(500).send({ "message": "error validating phone number" })
            }

        }
        const query = validPhoneNumber ? { phoneNumber: validPhoneNumber } : { email: params.email }
        const user = await User.findOne(query);
        if (!user) return res.status(400).send({ "message": `There is no user with ${validPhoneNumber? "phone" : "email"} : ${validPhoneNumber || params.email}` })

        //generate hashed password    
        try{
          const match = await bcrypt.compare(params.password,user.password)
          if(!match) return res.status(400).send({ "message": "Wrong password!" })
        }catch(e){
            console.error("error comparing password:",e)
            return res.status(500).send({"message":"Error comparing input password with stored password"})
        }

        const refreshToken = signRefreshToken({ "user_id": user.id })
        const accessToken = signAccessToken({ "user_id": user.id })

        //store the refresh and access tokens in the cookies for browsers (more secure than local-storage)
        res.cookie("refresh_token", refreshToken, refreshTokenOptions);
        res.cookie("access_token", accessToken, accessTokenOptions);
        return res.status(200).send({
            "access_token": accessToken,
            "refresh_token": refreshToken,
            "message": "signed In successfully"
        })
    } catch (e) {
        console.error("signIn error:", e)
        return res.status(500).json({ "message": "Internal Server Error" })
    }


}
export const signOut: RequestHandler = async (req, res, next) => {
    try {
      
    } catch (e) {
        console.error("createUser error:", e)
        return res.status(500).json({ "message": "Internal Server Error" })
    }


}
