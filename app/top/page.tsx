"use client"

import { useEffect, useState } from "react"
import { getRatings } from "@/lib/storage"
import DrinkCard from "@/components/DrinkCard"

export default function TopPage() {
  const [drinks, setDrinks] = useState<any[]>([])

  useEffect(() => {
    const loadTop = async () => {
      const ratings = getRatings()

      // ✅ filter out removed ratings
      const entries = Object.entries(ratings).filter(
        ([_, value]) => value > 0
      )

      // ✅ sort highest first
      entries.sort((a: any, b: any) => b[1] - a[1])

      const data = await Promise.all(
        entries.map(async ([id]) => {
          try {
            const res = await fetch(
              `https://www.thecocktaildb.com/api/json/v1/1/lookup.php?i=${id}`
            )
            const json = await res.json()
            return json.drinks?.[0] || null
          } catch {
            return null
          }
        })
      )

      setDrinks(data.filter(Boolean))
    }

    loadTop()

    // ✅ auto refresh
    const interval = setInterval(loadTop, 1000)

    return () => clearInterval(interval)
  }, [])

  return (
    <div className="p-6 text-white">
      <h1 className="text-3xl mb-6">⭐ Top Rated Drinks</h1>

      {drinks.length === 0 && <p>No ratings yet</p>}

      <div className="grid grid-cols-2 md:grid-cols-3 gap-4">
        {drinks.map((drink) => (
          <DrinkCard key={drink.idDrink} drink={drink} />
        ))}
      </div>
    </div>
  )
}
