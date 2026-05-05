"use client"

import { useState, useRef, useEffect } from "react"
import { useLanguage } from "@/context/LanguageProvider"

export default function LanguageSwitcher() {

  const [open, setOpen] = useState(false)
  const { lang, setLang } = useLanguage()
  const ref = useRef<any>(null)

  const languages = [
    "EN",
    "ES",
    "DE",
    "FR",
    "IT",
    "PT",
    "RU",
    "JP"
  ]

  useEffect(() => {
    function handle(e: any) {
      if (ref.current && !ref.current.contains(e.target)) {
        setOpen(false)
      }
    }

    document.addEventListener("mousedown", handle)
    return () => document.removeEventListener("mousedown", handle)
  }, [])

  return (
    <div ref={ref} style={{ position: "relative" }}>

      {/* BUTTON */}
      <div
        onClick={() => setOpen(!open)}
        style={{
          border: "1px solid cyan",
          padding: "7px 16px",
          borderRadius: 24,
          cursor: "pointer",
          background: "linear-gradient(180deg,#020012,#050024)",
          boxShadow: "0 0 14px rgba(0,255,255,0.6)",
          fontSize: 14,
          userSelect: "none",
          color:"#7df9ff"
        }}
      >
        🌐 {lang}
      </div>

      {/* DROPDOWN */}
      {open && (
        <div
          style={{
            zIndex: 9999,
            position: "absolute",
            top: 42,
            right: 0,
            width: 72,
            background: "#07001f",
            border: "1px solid #00ffff",
            borderRadius: 14,
            boxShadow:
              "0 0 6px #00ffff, 0 0 16px rgba(0,255,255,0.7), 0 0 28px rgba(0,255,255,0.45)",
            overflow: "hidden",
            animation: "fade .15s ease"
          }}
        >
          {languages.map(l => (
            <div
              key={l}
              onClick={() => {
                setLang(l)
                setOpen(false)
              }}
              onMouseEnter={(e:any)=> e.currentTarget.style.textShadow="0 0 10px #00ffff"}
              onMouseLeave={(e:any)=> e.currentTarget.style.textShadow="none"}
              style={{
                padding: "10px 18px",
                cursor: "pointer",
                whiteSpace: "nowrap",
                color: "#7df9ff",
                fontWeight: 500,
                transition: "0.2s"
              }}
            >
              {l}
            </div>
          ))}
        </div>
      )}

      <style>{`
        @keyframes fade {
          from { opacity:0; transform: translateY(-6px); }
          to { opacity:1; transform: translateY(0); }
        }
      `}</style>

    </div>
  )
}
