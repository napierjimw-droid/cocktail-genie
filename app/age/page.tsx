export default function AgePage() {
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
      <h1 style={{ color: "#00ffff" }}>🔞 Age Policy</h1>

      <p style={{ fontStyle: "italic", color: "#d4af37" }}>
        "Magic is for everyone… but cocktails are not."
      </p>

      <p style={{ marginTop: "20px" }}>
        Cocktail Genie is intended for users of legal drinking age in their
        country or region.
      </p>

      <p>
        By using this app, you confirm that you meet the legal requirements
        to view and engage with alcohol-related content.
      </p>

      <p>
        If you are under the legal drinking age, the genie politely asks you
        to come back later… much later.
      </p>

      <div
        style={{
          marginTop: "30px",
          padding: "15px",
          border: "1px solid rgba(0,255,255,0.3)",
          borderRadius: "12px",
          background: "rgba(0,255,255,0.05)",
        }}
      >
        <p style={{ fontSize: "13px", color: "#7df9ff" }}>
          Legal drinking age varies by country (commonly 18 or 21+).
          Please follow your local laws and regulations.
        </p>
      </div>

      <p style={{ marginTop: "20px", fontSize: "12px", opacity: 0.6 }}>
        Cocktail Genie and GenieVerse LLC are not responsible for misuse of this app.
      </p>
    </div>
  );
}
