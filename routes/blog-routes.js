import express from "express";
import pool from "../db.js";
import authenticateToken from "../middleware/authorization.js";

const router = express.Router();

// ✅ SAFE PARSER
const safeParse = (value, fallback = []) => {
  try {
    if (!value) return fallback;
    if (typeof value === "string") return JSON.parse(value);
    return value;
  } catch (e) {
    return fallback;
  }
};

// =========================
// ✅ CREATE BLOG
// =========================
router.post("/", async (req, res) => {
  const client = await pool.connect();

  try {
    let {
      title,
      slug,
      short_description,
      content,
      featured_image,
      featured_image_alt,
      author_name,
      meta_title,
      meta_description,
      meta_keywords,
      canonical_url,
      faqs,
      status,
      category_ids
    } = req.body;

    console.log("RAW BODY:", req.body);

    // ✅ SAFE PARSE
    category_ids = safeParse(category_ids, []);
    faqs = safeParse(faqs, []);

    await client.query("BEGIN");

    const blogResult = await client.query(
      `INSERT INTO blogs
      (title, slug, short_description, content, featured_image,
       featured_image_alt, author_name, meta_title,
       meta_description, meta_keywords, canonical_url,
       faqs, status)
      VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13)
      RETURNING *`,
      [
        title || "",
        slug || "",
        short_description || "",
        content || "",
        featured_image || "",
        featured_image_alt || "",
        author_name || "",
        meta_title || "",
        meta_description || "",
        meta_keywords || "",
        canonical_url || "",
        JSON.stringify(faqs), // ✅ IMPORTANT
        status || "draft"
      ]
    );

    const blog = blogResult.rows[0];

    // ✅ INSERT CATEGORIES
    if (category_ids.length > 0) {
      for (const catId of category_ids) {
        await client.query(
          `INSERT INTO blog_category_map (blog_id, category_id)
           VALUES ($1,$2)`,
          [blog.id, Number(catId)]
        );
      }
    }

    await client.query("COMMIT");

    res.status(201).json(blog);

  } catch (err) {
    await client.query("ROLLBACK");
    console.error(err);
    res.status(500).json({ error: err.message });
  } finally {
    client.release();
  }
});


// =========================
// ✅ UPDATE BLOG
// =========================
router.put("/:id", async (req, res) => {
  const client = await pool.connect();

  try {
    const { id } = req.params;

    let {
      title,
      slug,
      short_description,
      content,
      featured_image,
      featured_image_alt,
      author_name,
      meta_title,
      meta_description,
      meta_keywords,
      canonical_url,
      faqs,
      status,
      category_ids
    } = req.body;

    console.log("RAW BODY:", req.body);

    // ✅ SAFE PARSE
    category_ids = safeParse(category_ids, []);
    faqs = safeParse(faqs, []);

    await client.query("BEGIN");

    await client.query(
      `UPDATE blogs SET
        title = $1,
        slug = $2,
        short_description = $3,
        content = $4,
        featured_image = $5,
        featured_image_alt = $6,
        author_name = $7,
        meta_title = $8,
        meta_description = $9,
        meta_keywords = $10,
        canonical_url = $11,
        faqs = $12,
        status = $13,
        updated_at = CURRENT_TIMESTAMP
       WHERE id = $14`,
      [
        title || "",
        slug || "",
        short_description || "",
        content || "",
        featured_image || "",
        featured_image_alt || "",
        author_name || "",
        meta_title || "",
        meta_description || "",
        meta_keywords || "",
        canonical_url || "",
        JSON.stringify(faqs), // ✅ IMPORTANT
        status || "draft",
        id
      ]
    );

    // ✅ RESET CATEGORIES
    await client.query(
      `DELETE FROM blog_category_map WHERE blog_id = $1`,
      [id]
    );

    if (category_ids.length > 0) {
      for (const catId of category_ids) {
        await client.query(
          `INSERT INTO blog_category_map (blog_id, category_id)
           VALUES ($1,$2)`,
          [id, Number(catId)]
        );
      }
    }

    await client.query("COMMIT");

    res.json({ message: "Blog updated successfully" });

  } catch (err) {
    await client.query("ROLLBACK");
    console.error(err);
    res.status(500).json({ error: err.message });
  } finally {
    client.release();
  }
});


// =========================
// ✅ GET ALL BLOGS
// =========================
router.get("/", async (req, res) => {
  try {
    const result = await pool.query(`
      SELECT 
        b.*,
        COALESCE(
          json_agg(c.*) FILTER (WHERE c.id IS NOT NULL),
          '[]'
        ) as categories
      FROM blogs b
      LEFT JOIN blog_category_map bcm ON b.id = bcm.blog_id
      LEFT JOIN blog_categories c ON bcm.category_id = c.id
      GROUP BY b.id
      ORDER BY b.created_at DESC
    `);

    res.json(result.rows);

  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});


// =========================
// ✅ GET SINGLE BLOG
// =========================
router.get("/:slug", async (req, res) => {
  try {
    const { slug } = req.params;

    const result = await pool.query(`
      SELECT 
        b.*,
        COALESCE(
          json_agg(c.*) FILTER (WHERE c.id IS NOT NULL),
          '[]'
        ) as categories
      FROM blogs b
      LEFT JOIN blog_category_map bcm ON b.id = bcm.blog_id
      LEFT JOIN blog_categories c ON bcm.category_id = c.id
      WHERE b.slug = $1
      GROUP BY b.id
    `, [slug]);

    if (result.rows.length === 0) {
      return res.status(404).json({ message: "Blog not found" });
    }

    res.json(result.rows[0]);

  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});


// =========================
// ✅ DELETE BLOG
// =========================
router.delete("/:id", async (req, res) => {
  try {
    await pool.query(`DELETE FROM blogs WHERE id = $1`, [req.params.id]);
    res.json({ message: "Blog deleted successfully" });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

export default router;