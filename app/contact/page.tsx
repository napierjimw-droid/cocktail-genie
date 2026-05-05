"use client";

import { useState } from "react";

export default function ContactPage() {
  const [sent, setSent] = useState(false);

  return (
    <div
      style={{
        maxWidth: "700px",
        margin: "40px auto",
        padding: "20px",
        color: "#e0f7ff",
        textAlign: "center",
        lineHeight: 1.6,
      }}
    >
      <h1 style={{ color: "#00ffff" }}>📬 Contact the Genie</h1>

      <p style={{ fontStyle: "italic", color: "#d4af37" }}>
        "Whispers travel fast… but messages work better."
      </p>

      <p style={{ marginTop: "20px" }}>
        Found a bug? Have an idea? Want to praise the genie?
      </p>

      {!sent ? (
        <form
          onSubmit={(e) => {
            e.preventDefault();
            setSent(true);
          }}
          style={{
            marginTop: "20px",
            display: "flex",
            flexDirection: "column",
            gap: "10px",
          }}
        >
          <input
            placeholder="Your message..."
            required
            style={{
              padding: "10px",
              borderRadius: "8px",
              border: "1px solid #00ffff",
              background: "#111",
              color: "#00ffff",
            }}
          />

          <button
            type="submit"
            style={{
              padding: "10px",
              borderRadius: "8px",
              background: "#00ffff",
              color: "#000",
              fontWeight: "bold",
              cursor: "pointer",
            }}
          >
            Send Message ✨
          </button>
        </form>
      ) : (
        <p style={{ marginTop: "20px", color: "#00ffff" }}>
          🧞 Message received! The genie will respond soon.
        </p>
      )}

      <p style={{ marginTop: "20px", fontSize: "13px", opacity: 0.6 }}>
        Or email us directly: genieverse.contact@gmail.com
      </p>
    </div>
  );
}
