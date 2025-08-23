import express from "express";
import dotenv from "dotenv";
import eventsRouter from "./routers/events.ts";
import usersRouter from "./routers/events.ts";

import mongoose from "mongoose";
dotenv.config();
const app = express();

app.use(express.json())

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