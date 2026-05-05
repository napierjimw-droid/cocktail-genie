"use client"

import DrinkCard from "@/components/DrinkCard"
import { useEffect, useState } from "react"
import Link from "next/link"
import { getRatings } from "@/lib/storage"

export default function TopRatedPage() {
  const [drinks, setDrinks] = useState<any[]>([])

  useEffect(() => {
    const loadRated = async () => {
      const ratings = getRatings()

      const entries = Object.entries(ratings)
        .filter(([_, value]) => value > 0)
        .sort((a, b) => (b[1] as number) - (a[1] as number))

      if (entries.length === 0) {
        setDrinks([])
        return
      }

      const requests = entries.map(([id]) =>
        fetch(
          `https://www.thecocktaildb.com/api/json/v1/1/lookup.php?i=${id}`
        ).then((r) => r.json())
      )

      const results = await Promise.all(requests)

      const loaded = results
        .map((r) => r.drinks?.[0])
        .filter(Boolean)

      setDrinks(loaded)
    }

    loadRated()
  }, [])

  const ratings = getRatings()

  return (
    <div
      style={{
        minHeight: "100vh",
        background: "radial-gradient(circle at top, #1a0033, #050010)",
        padding: 40,
        color: "white"
      }}
    >
      <h1 style={{ fontSize: 34, marginBottom: 30 }}>
        ⭐ Top Rated Cocktails
      </h1>

      {drinks.length === 0 && <p>No rated drinks yet</p>}

      <div
        style={{
          display: "grid",
          gridTemplateColumns: "repeat(auto-fill,minmax(240px,1fr))",
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
