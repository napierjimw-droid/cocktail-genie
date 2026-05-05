"use client"

import { useRef, useState } from "react"
import { useRouter } from "next/navigation"
import CategoriesDropdown from "@/components/CategoriesDropdown"
import { CATEGORIES } from "@/lib/categories"

export default function CategoriesPage() {
  const [open, setOpen] = useState(false)
  const [selected, setSelected] = useState<string | null>(null)

  const btnRef = useRef<HTMLButtonElement>(null)
  const router = useRouter()

  return (
    <div style={{ padding: 40 }}>
      
      <button
        ref={btnRef}
        onClick={() => setOpen(!open)}
        style={{
          padding: "12px 20px",
          borderRadius: 999,
          background: "#111",
          color: "white",
          border: "1px solid cyan",
          cursor: "pointer"
        }}
      >
        Open Categories
      </button>

      <CategoriesDropdown
        anchorRef={btnRef}
        open={open}
        categories={CATEGORIES}
        selectedCategory={selected}
        onSelect={(id) => {
          setSelected(id)
          setOpen(false)
          router.push(`/categories/${id}`)
        }}
        onClose={() => setOpen(false)}
      />
    </div>
  )
}
