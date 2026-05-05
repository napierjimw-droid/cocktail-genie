export default function LegalPage() {
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
      <h1 style={{ color: "#00ffff" }}>⚖️ Legal Notice</h1>

      <p style={{ fontStyle: "italic", color: "#d4af37" }}>
        "The genie grants wishes… not liability."
      </p>

      <p style={{ marginTop: "20px" }}>
        Cocktail Genie provides cocktail recipes and suggestions for
        informational and entertainment purposes only.
      </p>

      <p>
        We do not guarantee accuracy, completeness, or that your drink will turn
        out Instagram-worthy.
      </p>

      <p>
        Consumption of alcohol is your responsibility. Please drink responsibly
        and follow all local laws and regulations.
      </p>

      <p>
        Cocktail Genie, GenieVerse LLC, and any associated magical entities are
        not liable for:
      </p>

      <ul style={{ textAlign: "left", marginTop: "15px" }}>
        <li>🍸 Poor cocktail decisions</li>
        <li>🥴 Hangovers</li>
        <li>💬 Questionable late-night messages</li>
        <li>🕺 Unexpected dance confidence</li>
      </ul>

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
          Data is provided by TheCocktailDB API. Please support them if you enjoy
          the service.
        </p>
      </div>

      <p style={{ marginTop: "20px", fontSize: "12px", opacity: 0.6 }}>
        By using this app, you agree to these terms.
      </p>
    </div>
  );
}
