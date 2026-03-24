import express, {json} from "express";
import cors from 'cors';
import cookieParser from "cookie-parser";
import dotenv from 'dotenv';
import {dirname,join} from 'path';
import { fileURLToPath } from "url";
import userRoutes from './routes/user-routes.js'
import authRoutes from './routes/auth-routes.js'
import categoryRoutes from "./routes/blogcategory-routes.js";
import blogRoutes from "./routes/blog-routes.js";
import imagesRoutes from "./routes/image-routes.js"
import contact from "./routes/contact.js"
import treatmentRoutes from "./routes/treatment-routes.js";

dotenv.config();

const __dirname = dirname(fileURLToPath(import.meta.url));

const app = express();
const PORT = process.env.PORT || 5000;
// const corsOptions = {Credential:true, origin: process.env.URL || '*'};
const allowedOrigins = [
  "http://localhost:3000",
  "http://localhost:3001",
  "https://admin.hclient.in"
];

const corsOptions = {
  credentials: true,
  origin: function (origin, callback) {
    if (!origin || allowedOrigins.includes(origin)) {
      callback(null, true);
    } else {
      callback(new Error("Not allowed by CORS"));
    }
  }
};

app.use(cors(corsOptions));
app.use(json());
app.use(cookieParser());
// app.use(authenticateToken)
app.use('/', express.static(join(__dirname,'public')));
app.use('/api/users', userRoutes);
app.use('/api/auth', authRoutes);
app.use('/api/blogcategories', categoryRoutes);
app.use("/api/blogs", blogRoutes);
app.use("/api/images", imagesRoutes);
app.use("/api/contact", contact);
app.use("/api/treatment", treatmentRoutes);

app.listen(PORT, ()=>console.log(`server is listening on ${PORT}`))