"use client"

import Link from "next/link"
import { useEffect, useState } from "react"
import {
  toggleFavorite,
  getFavorites,
  getRatings,
  setRating
} from "@/lib/storage"

type Props = {
  drink: any
}

export default function DrinkCard({ drink }: Props) {
  const [favorite, setFavorite] = useState(false)
  const [rating, setRatingState] = useState(0)

  // ✅ Load state
  useEffect(() => {
    const favs = getFavorites()
    const ratings = getRatings()

    setFavorite(favs.includes(drink.idDrink))
    setRatingState(ratings[drink.idDrink] || 0)
  }, [drink.idDrink])

  // ❤️ toggle
  const handleFavorite = (e: any) => {
    e.preventDefault()
    e.stopPropagation()

    toggleFavorite(drink.idDrink)

    const updated = getFavorites()
    setFavorite(updated.includes(drink.idDrink))
  }

  // ⭐ rating
const handleRating = (value: number, e: any) => {
  e.preventDefault()
  e.stopPropagation()

  // ⭐ toggle logic
  const newRating = value === rating ? 0 : value

  setRating(drink.idDrink, newRating)
  setRatingState(newRating)
}
  return (
    <div className="relative">

      {/* ❤️ FAVORITE BUTTON */}
      <button
        onClick={handleFavorite}
        className="absolute top-2 right-2 z-10 text-xl"
      >
        {favorite ? "❤️" : "🤍"}
      </button>

      {/* CARD */}
      <Link href={`/drink/${drink.idDrink}`}>
        <div className="card cursor-pointer">

          {/* IMAGE */}
          <div
            style={{
              width: "100%",
              height: "200px",
              background: "radial-gradient(circle at center, rgba(0,255,255,0.15), rgba(0,0,0,0.4))",
              display: "flex",
              justifyContent: "center",
              alignItems: "center",
              borderTopLeftRadius: "12px",
              borderTopRightRadius: "12px",
            }}
          >
            <img
              src={drink.strDrinkThumb}
              style={{
                maxWidth: "100%",
                maxHeight: "100%",
                objectFit: "contain",
                objectPosition: "center top",
              }}
            />
          </div>

          {/* CONTENT */}
          <div className="p-4">
            <h3 className="font-semibold text-lg">
              {drink.strDrink}
            </h3>

            <p className="text-sm text-gray-400">
              {drink.strCategory} • {drink.strAlcoholic}
            </p>

            {/* ⭐ RATING */}
            <div className="flex gap-1 mt-3">
              {[1,2,3,4,5].map((star) => (
                <button
                  key={star}
                  onClick={(e) => handleRating(star, e)}
                >
                  <span className="text-yellow-400 text-lg">
                    {star <= rating ? "★" : "☆"}
                  </span>
                </button>
              ))}
            </div>

          </div>
        </div>
      </Link>

    </div>
  )
}
