"use client"

import { useEffect, useState } from "react"
import { genieTales } from "@/lib/funFacts"

const cocktailIDs = ["11007", "11008", "11009", "11000", "11001"]

interface Cocktail {
  idDrink: string
  strDrink: string
  strDrinkThumb: string
  ingredients: string[]
}

export default function FunFactsPage() {

  const [cocktails, setCocktails] = useState<Cocktail[]>([])
  const [loading, setLoading] = useState(false)
  
  const fetchData = async () => {
  setLoading(true)

  const results = await Promise.all(
    Array.from({ length: 6 }).map(async () => {
      const res = await fetch(
        "https://www.thecocktaildb.com/api/json/v1/1/random.php"
      )
      const data = await res.json()
const drink = data.drinks[0]

const ingredients: string[] = []
for (let i = 1; i <= 5; i++) {
  const ing = drink[`strIngredient${i}`]
  if (ing) ingredients.push(ing)
}

return {
  ...drink,
  ingredients,
}
    })
  )

  setCocktails((prev) => [...prev, ...results])
  setLoading(false)
}
    useEffect(() => {
    fetchData()
  }, [])

const storyOpeners = [
  "In a distant desert,",
  "Long ago beneath a golden moon,",
  "In a hidden palace of glass,",
  "On a wind-swept island,",
  "In the shadow of ancient dunes,",
]

const storyActions = [
  "the Genie crafted",
  "the Genie revealed",
  "the Genie whispered of",
  "the Genie conjured",
  "the Genie offered",
]

const storyEndings = [
  "to a wandering soul.",
  "to those seeking magic.",
  "to a traveler in need.",
  "to a keeper of secrets.",
  "to one brave enough to try.",
]

const generateGenieStory = (name: string) => {
  const opener = storyOpeners[Math.floor(Math.random() * storyOpeners.length)]
  const action = storyActions[Math.floor(Math.random() * storyActions.length)]
  const ending = storyEndings[Math.floor(Math.random() * storyEndings.length)]

  return `${opener} ${action} a drink known as ${name} ${ending}`
}

  return (
    <div className="min-h-screen bg-black text-white p-6">

      {/* 🔥 TITLE */}
      <h1 className="text-4xl text-center mb-8 neon">
       🧞 Genie Tales
      </h1>

      {/* 🔹 GRID */}
      <div className="flex flex-wrap justify-center gap-6">

        {cocktails.map((drink) => (
          <div
            key={drink.idDrink}
            className="w-72 bg-zinc-900 rounded-2xl p-4 shadow-lg"
          >
            {/* IMAGE */}
            <img
              src={drink.strDrinkThumb}
              alt={drink.strDrink}
              className="w-full h-40 object-cover rounded-xl"
            />

            {/* NAME */}
            <h2 className="text-xl mt-3 font-semibold">
            The Tale of {drink.strDrink}
            </h2>

            <p className="text-xs text-purple-400 mt-1">
            whispered by the Genie
            </p>

<p className="text-sm text-gray-400 mt-2 italic">
{generateGenieStory(drink.strDrink)}
</p>

            {/* INGREDIENTS */}
            <p className="text-sm mt-2">
              {drink.ingredients.join(", ")}
            </p>

            {/* MAP BUTTON */}
            <button
              className="mt-4 w-full bg-purple-600 py-2 rounded-xl"
              onClick={() =>
                window.open(
                  `https://www.google.com/maps/search/${drink.strDrink}+cocktail+near+me`
                )
              }
            >
              Find 🍸
            </button>
          </div>
        ))}

      </div>

<div className="flex justify-center mt-8">
  <button
    onClick={fetchData}
    className="px-6 py-2 bg-cyan-500 rounded-xl hover:bg-cyan-400 transition"
  >
    {loading ? "Loading..." : "Load More 🧞"}
  </button>
</div>
      {/* NEON STYLE */}
      <style jsx>{`
        .neon {
          text-shadow:
            0 0 5px #ff00ff,
            0 0 10px #ff00ff,
            0 0 20px #ff00ff;
        }
      `}</style>
    </div>
  )
}
