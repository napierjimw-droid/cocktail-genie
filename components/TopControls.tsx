"use client"

import LanguageSwitcher from "./LanguageSwitcher"

export default function TopControls() {
return (
  <div
    style={{
      position: "fixed",
      top: 0,
      left: 0,
      width: "100%",
      height: 64,
      display: "flex",
      justifyContent: "center",
      alignItems: "center",
      background: "linear-gradient(to bottom, rgba(5,0,20,0.9), rgba(5,0,20,0.3))",
      backdropFilter: "blur(12px)",
      zIndex: 1000
    }}
  >
    <div
      style={{
        display: "flex",
        justifyContent: "space-between",
        width: "92%",
        maxWidth: 520
      }}
    >

      {/* USER */}
      <button
        style={{
          background: "rgba(20,0,60,0.55)",
          borderRadius: "50%",
          width: 42,
          height: 42,
          border: "1px solid cyan",
          color: "white",
          boxShadow: "0 0 12px rgba(0,255,255,0.4)"
        }}
      >
        👤
      </button>

      {/* LANGUAGE */}
       
	<LanguageSwitcher />


    </div>
  </div>
)
}
