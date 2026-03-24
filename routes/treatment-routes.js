import express from "express";
import pool from "../db.js";

const router = express.Router();

router.post("/add", async (req, res) => {
  try {
    let { title, slug, seo, data } = req.body;
    if (typeof seo === "string") seo = JSON.parse(seo);
    if (typeof data === "string") data = JSON.parse(data);

    const result = await pool.query(
      `INSERT INTO treatment_pages (title, slug, seo, data)
       VALUES ($1, $2, $3, $4)
       RETURNING *`,
      [title, slug, seo, data]
    );
    res.json({
      success: true,
      message: "Treatment created successfully",
      data: result.rows[0],
    });
  } catch (error) {
    console.error(error);
    if (error.code === "23505") {
      return res.status(400).json({
        success: false,
        message: "Slug already exists",
      });
    }
    res.status(500).json({
      success: false,
      message: "Error creating treatment",
    });
  }
});

router.post("/update/:id", async (req, res) => {
  try {
    const { id } = req.params;
    let { title, slug, seo, data } = req.body;
    if (typeof seo === "string") seo = JSON.parse(seo);
    if (typeof data === "string") data = JSON.parse(data);
    const result = await pool.query(
      `UPDATE treatment_pages
       SET title=$1, slug=$2, seo=$3, data=$4, updated_at=NOW()
       WHERE id=$5
       RETURNING *`,
      [title, slug, seo, data, id]
    );
    res.json({
      success: true,
      message: "Treatment updated successfully",
      data: result.rows[0],
    });
  } catch (error) {
    console.error(error);
    if (error.code === "23505") {
      return res.status(400).json({
        success: false,
        message: "Slug already exists",
      });
    }
    res.status(500).json({
      success: false,
      message: "Error updating treatment",
    });
  }
});


// ✅ GET ALL
router.get("/all", async (req, res) => {
  try {
    const result = await pool.query(`
    SELECT 
      id,
      title,
      slug,
      created_at,
      data->'breadcrumb'->>'breadimage' AS image
    FROM treatment_pages
    ORDER BY id DESC
  `);

    res.json({
      success: true,
      treatment: result.rows,
    });

  } catch (error) {
    console.error(error);
    res.status(500).json({
      success: false,
      message: "Error fetching treatments",
    });
  }
});


// ✅ GET SINGLE (BY SLUG)
router.get("/:slug", async (req, res) => {
  try {
    const { slug } = req.params;

    const result = await pool.query(
      "SELECT * FROM treatment_pages WHERE slug=$1",
      [slug]
    );

    if (!result.rows.length) {
      return res.status(404).json({
        success: false,
        message: "Treatment not found",
      });
    }

    res.json({
      success: true,
      treatment: result.rows[0],
    });

  } catch (error) {
    console.error(error);
    res.status(500).json({
      success: false,
      message: "Error fetching treatment",
    });
  }
});


// ✅ DELETE
router.delete("/delete/:id", async (req, res) => {
  try {
    const { id } = req.params;

    await pool.query(
      "DELETE FROM treatment_pages WHERE id=$1",
      [id]
    );

    res.json({
      success: true,
      message: "Treatment deleted successfully",
    });

  } catch (error) {
    console.error(error);
    res.status(500).json({
      success: false,
      message: "Error deleting treatment",
    });
  }
});


export default router;