"use client"

import { CATEGORIES } from "@/lib/categories"
import { useParams } from "next/navigation"
import { useEffect, useState } from "react"
import DrinkCard from "@/components/DrinkCard"

export default function CategoryPage() {
  const { type } = useParams()

  const category = CATEGORIES.find((c) => c.id === type)

  const [drinks, setDrinks] = useState<any[]>([])
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    fetchDrinks()
  }, [type])

const fetchDrinks = async () => {
  setLoading(true)   // 🔥 START loading

  const category = CATEGORIES.find((c) => c.id === type)

  if (!category) return

  let allDrinks: any[] = []

  for (const name of category.drinks) {
    const res = await fetch(
      `https://www.thecocktaildb.com/api/json/v1/1/search.php?s=${name}`
    )
    const data = await res.json()

    if (data.drinks) {
      allDrinks = [...allDrinks, ...data.drinks]
    }
  }

const unique = Array.from(
  new Map(allDrinks.map(d => [d.idDrink, d])).values()
)

setDrinks(unique)

setLoading(false)   // 🔥 END loading
}
return (
  <div style={{ padding: 40 }}>

<div
  style={{
    textAlign: "center",
    marginBottom: "30px"
  }}
>
  <h1
    style={{
      color: "#00ffff",
      fontSize: "36px",
      textShadow: "0 0 15px #00ffff88",
      marginBottom: "10px"
    }}
  >
    {category ? category.label : `Category: ${type}`}
  </h1>


<p style={{ color: "#aaa", fontSize: "14px" }}>
    {drinks.length} drinks found 🍸
  </p>
<p style={{ color: "#888", fontSize: "13px", marginTop: "6px" }}>
  {category?.description}
</p>

</div>
    {loading ? (
      <div
        style={{
          height: "60vh",
          display: "flex",
          alignItems: "center",
          justifyContent: "center",
          color: "#00ffff",
          fontSize: "20px"
        }}
      >
        ✨ Summoning drinks...
      </div>
    ) : (
      <div
        style={{
          display: "grid",
          gridTemplateColumns: "repeat(auto-fit, minmax(250px, 1fr))",
          gap: "20px",
        }}
      >
        {drinks.map((drink) => (
          <DrinkCard key={drink.idDrink} drink={drink} />
        ))}
      </div>
    )}

  </div>
)
}
