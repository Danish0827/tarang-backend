import nodemailer from "nodemailer";
import dotenv from "dotenv";
dotenv.config();
// ✅ transporter
export const transporter = nodemailer.createTransport({
    service: "gmail",
    auth: {
        user: process.env.EMAIL_USER,
        pass: process.env.EMAIL_PASS,
    },
});

// ✅ SMTP check (only once on startup)
transporter.verify((error, success) => {
    if (error) {
        console.error("❌ SMTP Error:", error);
    } else {
        console.log("✅ SMTP Ready");
    }
});

// ✅ Send mail function
export const sendContactMail = async (data) => {
    try {
        const { full_name, email, phone, subject, message } = data;

        const mailOptions = {
            from: `"Contact Form" <${process.env.EMAIL_USER}>`,
            to: process.env.EMAIL_USER, // admin email
            subject: `New Contact: ${subject || "No Subject"}`,
            html: `
                <h2>New Contact Form Submission</h2>
                <p><b>Name:</b> ${full_name}</p>
                <p><b>Email:</b> ${email}</p>
                <p><b>Phone:</b> ${phone || "-"}</p>
                <p><b>Subject:</b> ${subject || "-"}</p>
                <p><b>Message:</b><br/>${message}</p>
            `,
        };

        // ✅ ACTUAL EMAIL SEND
        const info = await transporter.sendMail(mailOptions);

        console.log("📩 Email sent:", info.messageId);

    } catch (error) {
        console.error("❌ Mail send failed:", error);
        throw error; // optional
    }
};