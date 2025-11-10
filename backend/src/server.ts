import "dotenv/config"; // auto-loads .env

import express from "express";
import eventsRouter from "./routers/events.ts";
import usersRouter from "./routers/users.ts";
import authRouter from "./routers/auth.ts";

import mongoose from "mongoose";

const app = express();

app.use(express.json())

app.use("/auth",authRouter)
app.use("/users",usersRouter)
app.use("/events", eventsRouter);
const launchApp = async () => {
    try {

        await mongoose.connect(process.env.MONGO_URL!);
        app.listen(process.env.PORT, (error) => {
            if (error) {
                console.error(error);
                return;
            }
            console.log("listening on port : ", process.env.PORT);

        });
    } catch (e) {
        console.error("error launching app:",e)
    }

}
launchApp();