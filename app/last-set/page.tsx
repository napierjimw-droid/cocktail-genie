"use client"

import { useState, useRef, useEffect } from "react"

export default function LastSetPage() {
  const [activeSection, setActiveSection] = useState<string | null>(null)

  const containerRef = useRef<HTMLDivElement>(null)

useEffect(() => {
    const handleClickOutside = (event: MouseEvent) => {
      if (
        containerRef.current &&
        !containerRef.current.contains(event.target as Node)
      ) {
        setActiveSection(null)
      }
    }

    document.addEventListener("mousedown", handleClickOutside)

    return () => {
      document.removeEventListener("mousedown", handleClickOutside)
    }
  }, [])

  const handleClick = (section: string) => {
    setActiveSection(prev => (prev === section ? null : section))
  }
  return (
      <div className="min-h-screen p-6 bg-gradient-to-b from-[#0a001a] via-[#140033] to-[#1f0050]">
<div ref={containerRef} className="max-w-md mx-auto">
<h1 className="text-3xl font-bold mb-8 flex items-center gap-3 text-cyan-300 drop-shadow-[0_0_10px_#00ffff]">
          🍸 Cocktail Kit
      </h1>

      <div className="max-w-md mx-auto flex flex-col gap-4 mb-6">
        
  <button
    onClick={() => handleClick("set")}
    className={`px-6 py-3 rounded-xl border text-cyan-200 transition-all duration-300
      ${activeSection === "set"
        ? "bg-cyan-500/20 border-cyan-400 shadow-[0_0_20px_#00ffff] animate-pulse"
        : "bg-white/5 border-white/10 hover:bg-cyan-500/10 hover:shadow-[0_0_10px_#00ffff]"
      }`}
  >
<span className={`${activeSection === "set" ? "animate-bounce" : ""}`}>
  🍸
</span>{" "}
Cocktail Set
  </button>

  <button
    onClick={() => handleClick("glasses")}
    className={`px-6 py-3 rounded-xl border text-cyan-200 transition-all duration-300
      ${activeSection === "glasses"
        ? "bg-cyan-500/20 border-cyan-400 shadow-[0_0_20px_#00ffff]"
        : "bg-white/5 border-white/10 hover:bg-cyan-500/10 hover:shadow-[0_0_10px_#00ffff]"
      }`}
  >
<span className={`${activeSection === "glasses" ? "animate-bounce" : ""}`}>
  🥂 
</span>{" "}
Cocktail Glasses
  </button>

  <button
    onClick={() => handleClick("ingredients")}
    className={`px-6 py-3 rounded-xl border text-cyan-200 transition-all duration-300
      ${activeSection === "ingredients"
        ? "bg-cyan-500/20 border-cyan-400 shadow-[0_0_20px_#00ffff]"
        : "bg-white/5 border-white/10 hover:bg-cyan-500/10 hover:shadow-[0_0_10px_#00ffff]"
      }`}
  >
<span className={`${activeSection === "ingredients" ? "animate-bounce" : ""}`}>
  🍋
</span>{" "}
Ingredients & Mixers
</button>

</div>
      </div>

<div
  className={`overflow-hidden transition-all duration-700 ease-in-out ${
    activeSection === "set"
      ? "max-h-40 opacity-100 mb-4"
      : "max-h-0 opacity-0"
  }`}
>
  <div className="p-4 border border-white/20 rounded-xl text-white bg-white/5 backdrop-blur shadow-[0_0_15px_rgba(0,255,255,0.2)]">
<div className="grid gap-3">
<div className="p-3 rounded-lg bg-white/10 border border-white/20 text-white shadow-[0_0_10px_rgba(0,255,255,0.15)]">
    🍸 Shaker – mix drinks with ice
  </div>
<div className="p-3 rounded-lg bg-white/10 border border-white/20 text-white shadow-[0_0_10px_rgba(0,255,255,0.15)]">
    🥄 Jigger – measure alcohol
  </div>
<div className="p-3 rounded-lg bg-white/10 border border-white/20 text-white shadow-[0_0_10px_rgba(0,255,255,0.15)]">
    🧊 Strainer – separate ice
  </div>
<div className="p-3 rounded-lg bg-white/10 border border-white/20 text-white shadow-[0_0_10px_rgba(0,255,255,0.15)]">
    🌿 Muddler – crush herbs/fruits
  </div>
</div>
  </div>
</div>

<div
  className={`overflow-hidden transition-all duration-700 ease-in-out ${
    activeSection === "glasses"
      ? "max-h-40 opacity-100 mb-4"
      : "max-h-0 opacity-0"
  }`}
>
  <div className="p-4 border border-white/20 rounded-xl text-white bg-white/5 backdrop-blur shadow-[0_0_15px_rgba(0,255,255,0.2)]">
<div className="grid gap-3">
<div className="p-3 rounded-lg bg-white/10 border border-white/20 text-white shadow-[0_0_10px_rgba(0,255,255,0.15)]">
    🍸 Martini Glass – for martinis
  </div>
<div className="p-3 rounded-lg bg-white/10 border border-white/20 text-white shadow-[0_0_10px_rgba(0,255,255,0.15)]">
    🍷 Coupe Glass – for shaken cocktails
  </div>
<div className="p-3 rounded-lg bg-white/10 border border-white/20 text-white shadow-[0_0_10px_rgba(0,255,255,0.15)]">
    🥤 Highball Glass – for tall drinks
  </div>
<div className="p-3 rounded-lg bg-white/10 border border-white/20 text-white shadow-[0_0_10px_rgba(0,255,255,0.15)]">
    🥃 Old Fashioned Glass – for whiskey cocktails
  </div>
</div>
  </div>
</div>

<div
  className={`overflow-hidden transition-all duration-700 ease-in-out ${
    activeSection === "ingredients"
      ? "max-h-40 opacity-100 mb-4"
      : "max-h-0 opacity-0"
  }`}
>
  <div className="p-4 border border-white/20 rounded-xl text-white bg-white/5 backdrop-blur shadow-[0_0_15px_rgba(0,255,255,0.2)]"> 
  <div className="grid gap-3">
<div className="flex items-center gap-3 p-3 rounded-lg bg-white/10 border border-white/20 text-white shadow-[0_0_10px_rgba(0,255,255,0.15)]">
  <img
    src="https://images.unsplash.com/photo-1587241321921-91a834d6d191"
    className="w-10 h-10 rounded-md object-cover"
  />
  <span>🍋 Citrus (lemon, lime)</span>
</div>
<div className="flex items-center gap-3 p-3 rounded-lg bg-white/10 border border-white/20 text-white shadow-[0_0_10px_rgba(0,255,255,0.15)]">
<img
  src="https://images.unsplash.com/photo-1604908554027-18d62c8b88c1"
  className="w-10 h-10 rounded-md object-cover"
/>
  <span>🍯 Simple Syrup </span>
</div>
<div className="flex items-center gap-3 p-3 rounded-lg bg-white/10 border border-white/20 text-white shadow-[0_0_10px_rgba(0,255,255,0.15)]">
<img
  src="https://images.unsplash.com/photo-1625944525903-d5d5d84c9f1d"
  className="w-10 h-10 rounded-md object-cover"
/>
  <span>🌿 Mint</span>
</div>
</div>
  </div>

 </div>
    </div>
  )
}
