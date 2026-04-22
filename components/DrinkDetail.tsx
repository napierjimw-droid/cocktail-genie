import IngredientList from "./IngredientList"     

// 👇 ADD THIS ABOVE your component
function getIngredients(drink: any) {
  const list = []

  for (let i = 1; i <= 15; i++) {
    const ingredient = drink[`strIngredient${i}`]
    const measure = drink[`strMeasure${i}`]

    if (ingredient) {
      list.push(`${measure || ""} ${ingredient}`.trim())
    }
  }

  return list
}

export default function DrinkDetail({ drink }: any) {
 if (!drink) return <div>Drink not found</div>;

 const ingredients = getIngredients(drink);

return (
  <div className="max-w-4xl mx-auto mt-10 p-6 rounded-2xl backdrop-blur-lg bg-white/10 border border-white/20 shadow-2xl">

    {/* TITLE */}
    <h1 className="text-4xl font-bold mb-4 bg-gradient-to-r from-cyan-400 to-purple-400 text-transparent bg-clip-text">
      {drink.strDrink}
    </h1>

    {/* INFO */}
    <div className="flex gap-4 text-sm opacity-80 mb-6">
      <span>{drink.strCategory}</span>
      <span>•</span>
      <span>{drink.strAlcoholic}</span>
      <span>•</span>
      <span>{drink.strGlass}</span>
    </div>

    {/* TOP: Image + Ingredients */}
    <div className="grid md:grid-cols-2 gap-8 items-start">

      {/* IMAGE */}
      <div className="flex justify-center">

<img
  src={drink.strDrinkThumb}
  alt={drink.strDrink}
  className="mt-2 max-h-[350px] object-contain rounded-xl shadow-[0_0_30px_rgba(0,255,255,0.3)]"
/>

      </div>

{/* INGREDIENTS */}
<div className="bg-white/5 p-4 rounded-xl border border-white/10 h-full">
  <h2 className="text-lg text-cyan-300">Ingredients</h2>
  <ul className="mt-2 space-y-1">
    {ingredients.map((item, i) => (
      <li key={i}>🍹 {item}</li>
    ))}
  </ul>
</div>
</div>

    {/* BOTTOM: Instructions */}
    <div className="mt-8 bg-white/5 p-4 rounded-xl border border-white/10">
      <h2 className="text-xl mb-3 text-cyan-300">
        Instructions
      </h2>
      <p className="leading-relaxed">
        {drink.strInstructions}
      </p>
    </div>

{/* 🎲 TRY ANOTHER BUTTON */}
<div className="mt-6 flex justify-center">
  <a
    href="/surprise"
    className="px-5 py-2 rounded-xl bg-cyan-500/20 hover:bg-cyan-500/40 transition shadow-[0_0_15px_rgba(0,255,255,0.3)]"
  >
    🎲 Try another
  </a>
</div>
</div>
)
}

