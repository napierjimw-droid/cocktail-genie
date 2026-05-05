"use client"

import { useEffect, useState } from "react"
import Link from "next/link"
import { getFavorites } from "@/lib/storage"
import DrinkCard from "@/components/DrinkCard"

export default function FavoritesPage() {
  const [drinks, setDrinks] = useState<any[]>([])

  useEffect(() => {
    const loadFavorites = async () => {
      const favIds = getFavorites()

const data = await Promise.all(
  favIds.map(async (id: string) => {
    try {
      const res = await fetch(
        `https://www.thecocktaildb.com/api/json/v1/1/lookup.php?i=${id}`
      )

      if (!res.ok) return null

      const text = await res.text()

      if (!text) return null

      const json = JSON.parse(text)

      return json.drinks?.[0] || null
    } catch (err) {
      console.error("Error loading favorite:", id, err)
      return null
    }
  })
)
      setDrinks(data.filter(Boolean))
    }

    loadFavorites()
  }, [])

  return (
    <div
      style={{
        minHeight: "100vh",
        background: "radial-gradient(circle at top, #1a0033, #050010)",
        padding: 40,
        color: "white"
      }}
    >
      <h1 style={{ fontSize: 34, marginBottom: 30 }}>❤️ Favorites</h1>

      {drinks.length === 0 && <p>No favorites yet</p>}

      <div
        style={{
          display: "grid",
          gridTemplateColumns: "repeat(auto-fill, minmax(240px, 1fr))",
          gap: 24
        }}
      >

{drinks.map((drink) => (
  <DrinkCard key={drink.idDrink} drink={drink} />
))}

      </div>
    </div>
  )
}
