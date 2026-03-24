import express from "express";
import pool from "../db.js";
import { sendContactMail } from "../utils/mailer.js";

const router = express.Router();

router.post("/", async (req, res) => {
    try {
        const { full_name, email, phone, subject, message } = req.body;
        console.log(req.body,"req.body");
        
        if (!full_name || !email || !message) {
            return res.status(400).json({
                success: false,
                error: "Full name, email, and message are required",
            });
        }
        const newContact = await pool.query(
            `INSERT INTO contacts 
            (full_name, email, phone, subject, message) 
            VALUES ($1, $2, $3, $4, $5) 
            RETURNING *`,
            [full_name, email, phone, subject, message]
        );
        try {
            await sendContactMail(req.body);
        } catch (mailErr) {
            console.error("Mail error:", mailErr.message);
        }

        res.status(201).json({
            success: true,
            data: newContact.rows[0],
        });
    } catch (error) {
        console.error(error);
        res.status(500).json({
            success: false,
            error: "Failed to submit contact form",
        });
    }
});

router.get("/", async (req, res) => {
    try {
        const { page = 1, limit = 10 } = req.query;
        const offset = (page - 1) * limit;

        const result = await pool.query(
            `SELECT * FROM contacts
             ORDER BY created_at DESC
             LIMIT $1 OFFSET $2`,
            [limit, offset]
        );

        res.json({
            success: true,
            count: result.rows.length,
            contacts: result.rows,
        });

    } catch (error) {
        console.error(error);
        res.status(500).json({
            error: "Failed to fetch contacts",
        });
    }
});

router.delete("/:id", async (req, res) => {
    try {
        const { id } = req.params;
        console.log(req.params,"req.paramsreq.paramsreq.params");
        

        const result = await pool.query(
            "DELETE FROM contacts WHERE id = $1 RETURNING *",
            [id]
        );

        if (result.rows.length === 0) {
            return res.status(404).json({
                success: false,
                error: "Contact not found",
            });
        }

        res.json({
            success: true,
            message: "Contact deleted successfully",
            data: result.rows[0],
        });

    } catch (error) {
        console.error(error);
        res.status(500).json({
            success: false,
            error: "Failed to delete contact",
        });
    }
});

export default router;