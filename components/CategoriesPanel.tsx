"use client"

import { useEffect, useState } from "react"

export default function CategoriesPanel() {

  const [open, setOpen] = useState(false)
  const [categories, setCategories] = useState<string[]>([])

  useEffect(() => {
    fetch("https://www.thecocktaildb.com/api/json/v1/1/list.php?c=list")
      .then(res => res.json())
      .then(data => {
        setCategories(data.drinks.map((d:any) => d.strCategory))
      })
  }, [])

  return (
    <div style={{ marginTop:20 }}>

      <div
        onClick={() => setOpen(!open)}
        style={{
          cursor:"pointer",
          padding:"12px 20px",
          borderRadius:20,
          border:"1px solid cyan",
          display:"inline-block",
          boxShadow:"0 0 12px cyan",
          fontWeight:600
        }}
      >
        🍹 Categories {open ? "▲" : "▼"}
      </div>

      {open && (
        <div
          style={{
            marginTop:16,
            display:"flex",
            gap:12,
            overflowX:"auto",
            paddingBottom:8
          }}
        >
          {categories.map(cat => (
            <div
              key={cat}
              style={{
                whiteSpace:"nowrap",
                padding:"8px 16px",
                borderRadius:16,
                border:"1px solid rgba(0,255,255,0.4)",
                boxShadow:"0 0 8px rgba(0,255,255,0.5)"
              }}
            >
              {cat}
            </div>
          ))}
        </div>
      )}

    </div>
  )
}
