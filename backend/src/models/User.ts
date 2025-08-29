import mongoose, { Schema } from "mongoose";


const userSchema = new Schema({
    email:{type:String,sparse: true,unique: true},
    password:{type:String,unique :true,sparse : true},
    fullName:{type:String,},
    phoneNumber:{type:String,sparse: true}
})

const User = mongoose.model("User",userSchema);

export default User;