import DrinkDetail from "@/components/DrinkDetail"

async function getRandomDrink() {
  try {
    const res = await fetch(
      "https://www.thecocktaildb.com/api/json/v1/1/random.php",
      { cache: "no-store" }
    )

    const data = await res.json()
    return data.drinks?.[0] || null
  } catch (err) {
    console.error("Random fetch error:", err)
    return null
  }
}

export default async function SurprisePage() {
  const drink = await getRandomDrink()

  return (
    <div className="min-h-screen bg-gradient-to-br from-black via-purple-900 to-black text-white">
      <DrinkDetail drink={drink} />
    </div>
  )
}
