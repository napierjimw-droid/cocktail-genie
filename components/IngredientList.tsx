export default function IngredientList({ drink }: any) {
  const ingredients = []

  for (let i = 1; i <= 15; i++) {
    const ingredient = drink[`strIngredient${i}`]
    const measure = drink[`strMeasure${i}`]

    if (ingredient) {
      ingredients.push({
        name: ingredient,
        measure: measure || "",
      })
    }
  }

  return (
    <ul className="space-y-2">
      {ingredients.map((item, index) => (
        <li key={index} className="flex justify-between border-b border-white/10 pb-1">
          <span>{item.name}</span>
          <span className="opacity-70">{item.measure}</span>
        </li>
      ))}
    </ul>
  )
}
