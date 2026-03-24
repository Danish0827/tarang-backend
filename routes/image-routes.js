import express from "express";
import pool from "../db.js";
import authenticateToken from "../middleware/authorization.js";
import { UTApi } from "uploadthing/server";

const utapi = new UTApi();
const router = express.Router();

router.get("/", async (req, res) => {
    // console.log(req.query,"getgtegetgetget");    
    try {
        const { page = 1, limit = 10, userId } = req.query;
        const offset = (page - 1) * limit;
        let query = `
      SELECT *
      FROM images
    `;
        const values = [];
        if (userId) {
            values.push(userId);
            query += ` WHERE user_id = $1 `;
        }
        query += `
      ORDER BY created_at DESC
      LIMIT $${values.length + 1}
      OFFSET $${values.length + 2}
    `;
        values.push(limit);
        values.push(offset);
        const result = await pool.query(query, values);
        res.json({
            success: true,
            count: result.rows.length,
            images: result.rows,
        });

    } catch (error) {
        console.error(error);
        res.status(500).json({
            error: "Failed to fetch images",
        });
    }
});

router.post("/", async (req, res) => {
    try {
        console.log("REQ BODY:", req.body);
        const {
            userId,
            url,
            fileKey,
            title,
            alt_text,
            caption,
            is_featured,
        } = req.body;

        if (!url || !fileKey) {
            return res.status(400).json({ error: "Missing file data" });
        }

        const result = await pool.query(
            `INSERT INTO images 
      (user_id, url, file_key, title, alt_text, caption, is_featured)
      VALUES ($1,$2,$3,$4,$5,$6,$7)
      RETURNING *`,
            [
                userId,
                url,
                fileKey,
                title,
                alt_text,
                caption,
                is_featured || false,
            ]
        );

        res.status(201).json(result.rows[0]);
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: "Server error" });
    }
});

router.put("/:id", async (req, res) => {
    try {
        console.log(req.body, "put data");

        const { title, alt_text, caption, is_featured } = req.body;

        const result = await pool.query(
            `UPDATE images
            SET title = $1,
                alt_text = $2,
                caption = $3,
                is_featured = $4,
                updated_at = NOW()
            WHERE id = $5
            RETURNING *`,
            [title, alt_text, caption, is_featured, req.params.id]
        );

        if (result.rows.length === 0) {
            return res.status(404).json({ error: "Not found" });
        }

        res.status(200).json(result.rows[0]);
    } catch (err) {
        res.status(500).json({ error: "Server error" });
    }
});

router.delete("/:file_key", async (req, res) => {
  try {
    const { file_key } = req.params;
    console.log("DELETE FILE KEY:", file_key);
    if (!file_key) {
      return res.status(400).json({ error: "file_key is required" });
    }
    const result = await pool.query(
      "SELECT * FROM images WHERE file_key = $1",
      [file_key]
    );
    if (!result.rows.length) {
      return res.status(404).json({ error: "Image not found" });
    }
    await utapi.deleteFiles([file_key]);
    console.log("Deleted from UploadThing");
    await pool.query(
      "DELETE FROM images WHERE file_key = $1",
      [file_key]
    );
    console.log("Deleted from DB");
    res.json({ success: true });
  } catch (err) {
    console.error("DELETE ERROR:", err);
    res.status(500).json({ error: err.message });
  }
});;

export default router;