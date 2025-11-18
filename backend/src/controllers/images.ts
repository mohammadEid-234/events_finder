import  type { RequestHandler } from "express";
import User from "../models/User.ts";

export const uploadImg: RequestHandler = async (req,res)=>{
    try {
        if(!req.file){
            return res.status(400).send("uploaded_image is not found in the request body")
        }
        console.log("req file: ", req.file)
        console.log("user_id: ", req["user_id"])
        const userId = req['user_id'];
        const updateRes = await User.updateOne({ _id: userId }, { $set: { imgUrl: req.file.path } })
        console.log("update imgUrl result :", updateRes)

        return res.status(200).send("success");
    } catch (e) {
        console.error("error uploading image:", e)
        return res.status(500).send("failed to upload image");

    }
}