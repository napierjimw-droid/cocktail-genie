"use client"

import { createContext, useContext, useEffect, useState } from "react"

const AppContext = createContext<any>(null)

export function AppProvider({ children }: any) {

  const [favorites, setFavorites] = useState<any[]>([])
  const [ratings, setRatings] = useState<any>({})

  /* ⭐ LOAD FROM LOCAL STORAGE */
  useEffect(() => {

    const fav = localStorage.getItem("favorites")
    const rate = localStorage.getItem("ratings")

    if (fav) setFavorites(JSON.parse(fav))
    if (rate) setRatings(JSON.parse(rate))

  }, [])

  /* ⭐ SAVE FAVORITES */
  useEffect(() => {
    localStorage.setItem("favorites", JSON.stringify(favorites))
  }, [favorites])

  /* ⭐ SAVE RATINGS */
  useEffect(() => {
    localStorage.setItem("ratings", JSON.stringify(ratings))
  }, [ratings])

  function toggleFavorite(drink: any) {

    setFavorites((prev:any[]) => {

      const exists = prev.find(f => f.idDrink === drink.idDrink)

      if (exists) {
        return prev.filter(f => f.idDrink !== drink.idDrink)
      }

      return [...prev, drink]
    })
  }

function rateDrink(drink:any, stars:number) {

  setRatings((prev:any) => {

    const next = { ...prev }

    if (stars === 0) {
      delete next[drink.idDrink]
    } else {
      next[drink.idDrink] = stars
    }

    return next
  })
}

  return (
    <AppContext.Provider
      value={{
        favorites,
        toggleFavorite,
        ratings,
        rateDrink
      }}
    >
      {children}
    </AppContext.Provider>
  )
}

export function useApp() {
  return useContext(AppContext)
}
