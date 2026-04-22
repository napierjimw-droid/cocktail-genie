"use client"

import { useState } from "react"

export default function GenieHero({ magic }: any) {
  const [joke, setJoke] = useState<string | null>(null)

  const jokes = [
    "I recommend something with rum.",
    "Stir… don’t anger the spirits.",
    "You look like a margarita person.",
    "Wish granted. Hangover not included.",
    "Ice is just water’s glow-up."
  ]

  function tellJoke() {
    const j = jokes[Math.floor(Math.random() * jokes.length)]
    setJoke(j)
    setTimeout(() => setJoke(null), 2500)
  }

  return (
    <div
      style={{
        position: "relative",
        display: "flex",
        flexDirection: "column",
        alignItems: "center",
        textAlign: "center",
        marginBottom: 40
      }}
    >

{/* ✨ Sparkles */}
<span className="sparkle" style={{ top: "-10px", left: "10%" }}>✦</span>
<span className="sparkle" style={{ top: "0px", right: "10%" }}>✦</span>
<span className="sparkle" style={{ top: "-20px", left: "50%" }}>✦</span>

{/* 🌫️ GLOW BACKGROUND (ADD THIS FIRST) */}
<div
  style={{
    position: "absolute",
    top: "-20px",
    left: "50%",
    transform: "translateX(-50%)",
    width: "300px",
    height: "120px",
    background: "radial-gradient(circle, rgba(0,255,255,0.2), transparent 70%)",
    filter: "blur(20px)",
    zIndex: -1,
  }}
/>

      {/* TITLE */}
<h1
  className="shimmer-text"
  style={{
    fontFamily: "'Marcellus', serif",
    fontSize: "52px",
    letterSpacing: "4px",
    textShadow: "0 0 20px rgba(0,255,255,0.3)",
  }}
>
  Cocktail Genie
</h1>

<div
  style={{
    width: "120px",
    height: "2px",
    margin: "10px auto",
    background: "linear-gradient(to right, transparent, #d4af37, transparent)",
  }}
/>
<p
  style={{
    fontFamily: "'Playfair Display', serif",
    fontSize: "15px",
    color: "#d4af37",
    letterSpacing: "1px",
    fontStyle: "italic",
    opacity: 0.9,
  }}
>
"From desert winds to crystal glass... your drink awaits."
</p>

      {/* TAGLINE */}
      <p
        style={{
          color: "#7df9ff",
          fontSize: 18,
          marginBottom: 10,
fontStyle: "italic",
letterSpacing: "1px"
        }}
      >
        Summon the perfect coctail
      </p>

      {/* GENIE */}
      <div
        style={{
          width: 350,
          height: 350,
          display: "flex",
          justifyContent: "center",
          alignItems: "center",
          borderRadius: "50%",
          background:
            "radial-gradient(circle, rgba(0,255,255,0.14) 0%, rgba(0,255,255,0.05) 40%, transparent 70%)",
          animation: "auraPulse 5s ease-in-out infinite"
        }}
      >
        <img
          src="/genie.png"
          onClick={tellJoke}
          style={{
            width: 420,
            cursor: "pointer",
            transition: "transform 0.3s ease",
            animation: magic
              ? "pulse 0.6s"
              : "float 4s ease-in-out infinite"
          }}
          onMouseEnter={(e) =>
            (e.currentTarget.style.transform = "scale(1.1)")
          }
          onMouseLeave={(e) =>
            (e.currentTarget.style.transform = "scale(1)")
          }
        />
      </div>

      {/* JOKE */}
      {joke && (
        <div
style={{
  position: "absolute",
  top: 320,
  background: "rgba(0, 0, 0, 0.85)",
  padding: "12px 18px",
  borderRadius: 14,
  border: "1px solid #00ffff",
  boxShadow: "0 0 18px rgba(0, 255, 255, 0.8)",
  fontSize: 14,
  color: "#00ffff",
  animation: "fadeIn 0.3s ease",
  backdropFilter: "blur(6px)"
}}
        >
          🧞 {joke}
        </div>
      )}

      {/* ANIMATIONS */}
      <style>{`
        @keyframes float {
          0% { transform: translateY(0px); }
          50% { transform: translateY(-12px); }
          100% { transform: translateY(0px); }
        }

        @keyframes pulse {
          0% { transform: scale(1); filter: drop-shadow(0 0 20px cyan); }
          50% { transform: scale(1.12); filter: drop-shadow(0 0 60px cyan); }
          100% { transform: scale(1); }
        }

        @keyframes auraPulse {
          0% { transform: scale(1); opacity: 0.9; }
          50% { transform: scale(1.08); opacity: 1; }
          100% { transform: scale(1); opacity: 0.9; }
        }
@keyframes fadeIn {
  from { opacity: 0; transform: translateY(10px); }
  to { opacity: 1; transform: translateY(0); }
}
      `}</style>

    </div>
  )
}
