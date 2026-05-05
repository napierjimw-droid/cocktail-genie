export default function AboutPage() {
  return (
    <div
      style={{
        maxWidth: "700px",
        margin: "40px auto",
        padding: "20px",
        color: "#e0f7ff",
        lineHeight: 1.6,
        textAlign: "center",
      }}
    >
      <h1
        style={{
          fontSize: "32px",
          color: "#00ffff",
          textShadow: "0 0 10px rgba(0,255,255,0.6)",
          marginBottom: "10px",
        }}
      >
        🧞 About the Genie
      </h1>

      <p style={{ fontStyle: "italic", color: "#d4af37" }}>
        "Not all wishes come true… but cocktails usually do."
      </p>

      <p style={{ marginTop: "20px" }}>
        Brought to you by GenieVerse LLC—mixing magic and cocktails across all realms. Your wishes (and drinks) granted with a wink!”
        Cocktail Genie is your magical companion for discovering drinks from every corner of the world.
        Whether you crave a classic, something exotic, or a surprise you didn’t know you needed —
        the genie is always ready to serve.
      </p>

      <p>
        This app was built for explorers, curious minds, and anyone who believes
        that the perfect cocktail is just one wish away.
      </p>

      <p>
        Browse, search, save favorites, and let a little chaos guide your next drink.
        After all… the best discoveries are often accidental.
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
        <p style={{ fontSize: "14px", color: "#7df9ff" }}>
          Powered by TheCocktailDB API 🍸  
          (and a slightly mischievous genie)
        </p>
      </div>
    </div>
  );
}
