export const getFavorites = (): string[] => {
  if (typeof window === "undefined") return []
  return JSON.parse(localStorage.getItem("favorites") || "[]")
}

export const toggleFavorite = (id: string) => {
  const favorites = getFavorites()
  const updated = favorites.includes(id)
    ? favorites.filter(f => f !== id)
    : [...favorites, id]

  localStorage.setItem("favorites", JSON.stringify(updated))
  return updated
}

export const getRatings = (): Record<string, number> => {
  if (typeof window === "undefined") return {}
  return JSON.parse(localStorage.getItem("ratings") || "{}")
}

export const setRating = (id: string, rating: number) => {
  const ratings = getRatings()
  ratings[id] = rating
  localStorage.setItem("ratings", JSON.stringify(ratings))
  return ratings
}
