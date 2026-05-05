import DrinkDetail from "@/components/DrinkDetail"
import { redirect } from "next/navigation"

async function getDrink(id: string) {
  try {
    const res = await fetch(
      `https://www.thecocktaildb.com/api/json/v1/1/lookup.php?i=${id}`
    )

    if (!res.ok) {
      throw new Error("Failed to fetch drink")
    }

    const data = await res.json()
    return data.drinks?.[0] || null
  } catch (err) {
    console.error("Fetch error:", err)
    return null
  }
}

export default async function DrinkPage({ params }: any) {
  const { id } = await params

  // 🚨 guard invalid URLs
  if (!id || !/^\d+$/.test(id)) {
    redirect("/genie-ai")
  }

  const drink = await getDrink(id)

  return (
    <div className="min-h-screen bg-gradient-to-br from-black via-purple-900 to-black text-white">
      <div className="absolute top-0 left-0 w-full h-full bg-[radial-gradient(circle_at_20%_20%,rgba(0,255,255,0.15),transparent_40%),radial-gradient(circle_at_80%_80%,rgba(255,0,255,0.15),transparent_40%)] pointer-events-none" />

      <div className="relative z-10">
        <DrinkDetail drink={drink} />
      </div>
    </div>
  )
}
