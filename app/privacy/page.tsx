export default function PrivacyPage() {
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
      <h1 style={{ color: "#00ffff" }}>🔐 Privacy Policy</h1>

      <p style={{ fontStyle: "italic", color: "#d4af37" }}>
        "Your secrets are safe… even from the genie."
      </p>

      <p style={{ marginTop: "20px" }}>
        We respect your privacy. Cocktail Genie does not collect personal
        information unless you voluntarily provide it (for example, via contact).
      </p>

      <p>
        We do not sell, trade, or magically teleport your data to third parties.
        What happens in the app… stays in the app.
      </p>

      <p>
        Some non-personal data (like usage patterns) may be collected to improve
        the experience — think of it as the genie learning your taste.
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
          Third-party services (like TheCocktailDB API) may operate under their
          own privacy policies.
        </p>
      </div>

      <p style={{ marginTop: "20px", fontSize: "12px", opacity: 0.6 }}>
        By using this app, you agree to this policy. Laws vary by country — follow
        your local regulations.
      </p>
    </div>
  );
}
