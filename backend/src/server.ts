import "dotenv/config"; // auto-loads .env

import express from "express";
import eventsRouter from "./routers/events.ts";
import usersRouter from "./routers/users.ts";
import authRouter from "./routers/auth.ts";
import imagesRouter from "./routers/images.ts"
import mongoose from "mongoose";
import cookie from "cookie-parser"
const app = express();
console.log(".env Images path:",process.env.IMAGES_PATH)
app.use(express.json())
app.use(cookie())
app.use("/uploads",express.static(process.env.IMAGES_PATH || "public/uploads/photos"))
app.use("/auth",authRouter)
app.use("/users",usersRouter)
app.use("/events", eventsRouter);
app.use("/images",imagesRouter)

const launchApp = async () => {
    try {

        await mongoose.connect(process.env.MONGO_URL!);
        const port = parseInt(process.env.PORT || "3000", 10);
        const server = app.listen(port, () => {
            console.log("listening on port : ", port);
        });
        server.on("error", (error: any) => {
            console.error(error);
        });
    } catch (e) {
        console.error("error launching app:",e)
    }

}
launchApp();