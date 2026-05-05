"use client"

import { useEffect, useRef } from "react"
import { useState } from "react"

export default function CategoriesDropdown({
  anchorRef,
  open,
  categories,
  selectedCategory,
  onSelect,
  onClose 
}: any) {

if (!open) return null

const ref = useRef<HTMLDivElement>(null)
const [pos, setPos] = useState({ top: 0, left: 0 })

useEffect(() => {
if (!open || !anchorRef?.current) return
  function handleClick(e: MouseEvent) {
    if (ref.current && !ref.current.contains(e.target as Node)) {
      onClose()
    }
  }

  document.addEventListener("mousedown", handleClick)

  return () => {
    document.removeEventListener("mousedown", handleClick)
  }
}, [])
useEffect(() => {

  function update() {
    if (!anchorRef?.current) return

    const r = anchorRef.current.getBoundingClientRect()

    setPos({
      top: r.bottom + 12,
      minWidth: 220,
      left: r.left + r.width / 2 - 120 // center dropdown
    })
  }

  update()

  window.addEventListener("scroll", update)
  window.addEventListener("resize", update)

  return () => {
    window.removeEventListener("scroll", update)
    window.removeEventListener("resize", update)
  }

}, [open])

  if (!open) {
    return null
  }
  return (
    <div
ref={ref}
style={{
  position: "fixed",
  top: pos.top,
  left: pos.left,
  background: "#0d0225",
  border: "1px solid rgba(0,255,255,0.25)",
  borderRadius: 16,
  padding: 12,
  boxShadow: "0 10px 40px rgba(0,0,0,0.6)",
  zIndex: 50,
  animation:"genieDrop 0.22s cubic-bezier(.2,.9,.3,1)",
  transformOrigin:"top center",

  maxHeight:"60vh",
  overflowY:"auto"
}}
    >
      <div
        style={{
          display:"flex",
          flexDirection:"column",
          gap:6,
          overflowX:"auto",
          paddingBottom:6
        }}
      >

{categories.map((c: any) => (
<button
  key={c.id}
  onClick={() => onSelect(c.id)}
  onMouseEnter={(e) => {
    if (selectedCategory !== c.id) {
      e.currentTarget.style.background = "rgba(0,255,255,0.2)"
    }
  }}
  onMouseLeave={(e) => {
    if (selectedCategory !== c.id) {
      e.currentTarget.style.background = "transparent"
    }
  }}
  style={{
    padding: "10px 18px",
    borderRadius: 999,
    border: "1px solid cyan",
    background:
      selectedCategory === c.id
        ? "#00ffff22"
        : "transparent",
    color: "white",
    cursor: "pointer",
    whiteSpace: "nowrap",
    transition: "0.2s"
  }}
>
  {c.label}
</button>
))}

      </div>
    </div>
  )
}
