import { Router } from "express";
import type {RequestHandler} from "express";
import { createEvent } from "../controllers/events.ts";

const middleware :RequestHandler = async(req,res,next)=>{

}
const router = Router();
router.get("/",middleware,createEvent)
export default router;
