"use client"

import { useEffect, useState } from "react"
import { useParams } from "next/navigation"
import { useApp } from "@/components/AppProvider"

export default function CocktailDetailsPage() {

  const { id } = useParams()

  const { toggleFavorite, favorites, rateDrink, ratings } = useApp()

  const [drink, setDrink] = useState<any>(null)

  const [genieLine, setGenieLine] = useState("")
  
useEffect(() => {

    async function load() {

      const res = await fetch(
        `https://www.thecocktaildb.com/api/json/v1/1/lookup.php?i=${id}`
      )

      const json = await res.json()

      setDrink(json.drinks?.[0])
    }

    load()
const comments = [
  "A timeless potion… handle with care.",
  "I sense citrus magic in this one.",
  "Perfect choice for a midnight toast.",
  "Even spirits would envy this mix.",
  "Stir gently… destiny is fragile."
]

setGenieLine(
  comments[Math.floor(Math.random()*comments.length)]
)
  }, [id])

  if (!drink)
    return (
      <div style={{
        minHeight:"100vh",
        background:"#050010",
        color:"white",
        padding:40
      }}>
        Loading magical recipe...
      </div>
    )

  const isFav = favorites.find(f => f.idDrink === drink.idDrink)
  const stars = ratings[drink.idDrink] || 0

const {
  strCategory,
  strGlass,
  strAlcoholic,
  strTags
} = drink
  
function getIngredients() {

    const list = []

    for (let i = 1; i <= 15; i++) {

      const ing = drink[`strIngredient${i}`]
      const meas = drink[`strMeasure${i}`]

      if (ing) list.push(`${meas || ""} ${ing}`)
    }

    return list
  }

  return (
    <div
      style={{
        minHeight:"100vh",
        background:"radial-gradient(circle at top,#1a0033,#050010)",
        padding:40,
        color:"white",
        fontFamily:"sans-serif",
        display:"flex",
        flexDirection:"column",
        alignItems:"center"
      }}
    >

      <h1 style={{ fontSize:36 }}>
        {drink.strDrink}
      </h1>

<div style={{ position:"relative" }}>

  {/* 🍸 Alcohol badge */}
  <div style={{
    position:"absolute",
    left:14,
    top:14,
    background:"rgba(0,0,0,0.6)",
    padding:"6px 14px",
    borderRadius:999,
    fontSize:13,
    backdropFilter:"blur(6px)"
  }}>
    {drink.strAlcoholic === "Alcoholic"
      ? "🍸 Alcoholic"
      : "🥤 Non-Alcoholic"}
  </div>

<div style={{
  width:"min(520px, 92vw)",
  margin:"0 auto 28px",
  borderRadius:28,
  overflow:"hidden",
  boxShadow:"0 0 80px rgba(0,255,255,0.65), 0 0 140px rgba(0,255,255,0.25)",
  border:"1px solid rgba(0,255,255,0.35)",
}}>

  <img
    src={drink.strDrinkThumb}
    style={{
      width:"100%",
      height:340,
      objectFit:"contain",
      display:"#000"
    }}
  />

</div>

</div>

{/* 🏷 META INFO */}
<div style={{
  marginTop:14,
  padding:"14px 16px",
  borderRadius:20,
  width:"min(520px, 92vw)",
  background:"rgba(0,255,255,0.08)",
  border:"1px solid rgba(0,255,255,0.4)",
  backdropFilter:"blur(14px)",
  boxShadow:"0 0 40px rgba(0,255,255,0.35), 0 0 80px rgba(0,255,255,0.15)"
}}>
<div style={{
  display:"flex",
  gap:10,
  flexWrap:"wrap"
}}>

  <span style={{
    padding:"6px 12px",
    borderRadius:999,
    background:"rgba(0,255,255,0.15)",
    border:"1px solid rgba(0,255,255,0.4)",
    fontSize:13
  }}>
    🍸 {strCategory}
  </span>

  <span style={{
    padding:"6px 12px",
    borderRadius:999,
    background:"rgba(255,255,255,0.08)",
    border:"1px solid rgba(255,255,255,0.2)",
    fontSize:13
  }}>
    🥂 {strGlass}
  </span>

  <span style={{
    padding:"6px 12px",
    borderRadius:999,
    background:"rgba(255,100,150,0.12)",
    border:"1px solid rgba(255,100,150,0.35)",
    fontSize:13
  }}>
    {strAlcoholic === "Alcoholic"
      ? "🍷 Alcoholic"
      : "🥤 Non-Alcoholic"}
  </span>

</div>
</div>

{/* ✨ TAGS */}
{strTags && (
  <div style={{
    display:"flex",
    flexWrap:"wrap",
    gap:8,
    marginTop:10,
    width:"min(520px, 92vw)"
  }}>
    {strTags.split(",").map((tag:string)=>(
      <span
        key={tag}
        style={{
          padding:"6px 10px",
          fontSize:12,
          borderRadius:999,
          background:"rgba(255,255,255,0.08)"
        }}
      >
        {tag}
      </span>
    ))}
  </div>
)}

      {/* ACTIONS */}
      <div style={{ marginTop:20 }}>

<button
  onClick={()=>toggleFavorite(drink)}
  style={{
    fontSize:18,
    background:"none",
    border:"none",
    color:"rgba(255,255,255,0.9)"
  }}
>
  {isFav ? "❤️" : "🤍"}
</button>

      </div>

<div
  style={{
    marginTop:24,
    background:"#120033",
    padding:"12px 18px",
    borderRadius:16,
    boxShadow:"0 0 20px rgba(0,255,255,0.3)",
    maxWidth:340,
    textAlign:"center"
  }}
>
  🧞‍♂️ {genieLine}
</div>
      {/* INGREDIENTS */}
      <div
        style={{
          marginTop:40,
          background:"rgba(0,255,255,0.06)",
          border:"1px solid rgba(0,255,255,0.35)",
          backdropFilter:"blur(12px)",
          boxShadow:"0 0 30px rgba(0,255,255,0.25), 0 0 60px rgba(0,255,255,0.1)",
          padding:20,
          borderRadius:18,
          width:"min(520px, 92vw)"
        }}
      >

        <h2>🍸 Ingredients</h2>

        <ul style={{ marginTop:10 }}>
          {getIngredients().map((i,idx)=>(
            <li key={idx}>{i}</li>
          ))}
        </ul>

      </div>

      {/* INSTRUCTIONS */}
      <div
         style={{
         marginTop:40,
         background:"rgba(0,255,255,0.06)",
         border:"1px solid rgba(0,255,255,0.35)",
         backdropFilter:"blur(12px)",
         boxShadow:"0 0 30px rgba(0,255,255,0.25), 0 0 60px rgba(0,255,255,0.1)",
         padding:20,
         borderRadius:18,
         width:"min(520px, 92vw)"
         }}
      >

        <h2>📜 Instructions</h2>

<p style={{
  lineHeight:1.6,
  opacity:0.9,
  marginTop:8
}}>
  {drink.strInstructions}
</p>
      </div>

<div style={{ height:120 }} />

{/* 🧲 STICKY ACTION BAR */}
<div style={{
  position:"fixed",
  bottom:120,
  left:0,
  width:"100%",
  padding:"0 16px"
}}>
  <div style={{
    background:"rgba(0,255,255,0.08)",
    border:"1px solid rgba(0,255,255,0.5)",
    backdropFilter:"blur(12px)",
    borderRadius:20,
    padding:"12px 16px",
    display:"flex",
    justifyContent:"space-between",
    alignItems:"center",
    boxShadow:"0 0 60px rgba(0,255,255,0.5), 0 0 120px rgba(0,255,255,0.2)",    
    backdropFilter:"blur(16px)"
  }}>


{/* ⭐ */}
<div>
  {[1,2,3,4,5].map((n) => {
    return (
      <span
        key={n}
        onClick={() => rateDrink(drink, stars === n ? 0 : n)}
        style={{
          fontSize: 22,
          cursor: "pointer",
          opacity: n <= stars ? 1 : 0.4,
          marginRight: 4
        }}
      >
        ⭐
      </span>
    )
  })}
</div>

    {/* 🔗 */}
    <button
      onClick={()=>{
        navigator.clipboard.writeText(window.location.href)
      }}
style={{
  fontSize:18,
  background:"none",
  border:"none",
  color:"rgba(255,255,255,0.9)"
}}
    >
      🔗
    </button>

  </div>
</div>
    </div>
  )
}
