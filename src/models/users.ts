import { Schema } from "mongoose";


const userSchema = new Schema({
    username:String,
    password:String,
    phoneNumber:{type:String,}

})