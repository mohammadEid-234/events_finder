import type { RequestHandler } from "express";
import Joi from "joi";
import { parsePhoneNumberWithError } from "libphonenumber-js";

export const createUser:RequestHandler = async (req,res,next)=>{
    console.log(req.body)
    if(!req.body) return res.status(400).send({"message":"Invalid json"});
    
    const paramsSchema = Joi.object({
        first_name:Joi.string().required(),
        last_name:Joi.string().required(),
        phone_number: Joi.string().required(),
        email:Joi.string().required(),
        password : Joi.string().required()
    }).xor("phone_number","email")
    const {error,value: params} = paramsSchema.validate(req.body,{errors: {wrap : {label : ""}}})
    if(error) return res.status(400).send({"message" : error.message})
    parsePhoneNumberWithError(params.phone_number,"PS")
}