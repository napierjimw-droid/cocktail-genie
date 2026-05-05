export default function RefundsPage() {
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
      <h1 style={{ color: "#00ffff" }}>💸 Refund Policy</h1>

      <p style={{ fontStyle: "italic", color: "#d4af37" }}>
        "Wishes, once granted, cannot be taken back."
      </p>

      <p style={{ marginTop: "20px" }}>
        Cocktail Genie provides digital experiences and content instantly.
        Because of this, all interactions are considered fulfilled immediately.
      </p>

      <p>
        As a result, refunds are generally not available once the service has
        been used.
      </p>

      <p style={{ marginTop: "20px" }}>
        However, if something is broken or not working correctly,
        please contact us — we will fix the issue as quickly as possible.
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
          This policy applies globally. Local consumer protection laws may
          override certain conditions.
        </p>
      </div>

      <p style={{ marginTop: "20px", fontSize: "12px", opacity: 0.6 }}>
        GenieVerse LLC reserves the right to update this policy at any time.
      </p>
    </div>
  );
}
