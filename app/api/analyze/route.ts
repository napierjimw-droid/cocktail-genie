import OpenAI from "openai"
import { NextResponse } from "next/server"

const openai = new OpenAI({
  apiKey: process.env.OPENAI_API_KEY!,
})

export async function POST(req: Request) {
  try {
    const { images } = await req.json()
if (images.length > 2) {
  return NextResponse.json({ error: "Too many images" })
}

// 🔥 TEMP LIMIT (cost protection)
if (images.length > 2) {
  return NextResponse.json({
    error: "Too many images (max 2 for now)"
  }, { status: 400 })
}

    const imageInputs = images.map((img: string) => ({
      type: "input_image",
      image_url: img,
    }))

    const response = await openai.responses.create({
      model: "gpt-4.1-mini",
      input: [
        {
          role: "user",
          content: [
            {
              type: "input_text",
              text: `You are a cocktail and liquor recognition expert.

Step 1: Carefully analyze the image and identify:
- Alcohol types (vodka, whiskey, rum, etc.)
- Brand names if visible (e.g., Jim Beam, Absolut, Jack Daniels)

Focus on reading labels and logos.

Rules:
- If brand name is readable → include it
- If not → return only alcohol type
- Do NOT invent brands

Step 2: Suggest cocktails based on detected alcohol types.

Return JSON ONLY:

{
  "ingredients": [],
  "bottles": [],
  "drinks": [],
  "confidence": []
}
              `,
            },
            ...imageInputs,
          ],
        },
      ],
    })

    const text = response.output_text
    let cleaned = text
  .replace(/```json/g, "")
  .replace(/```/g, "")
  .trim()

let parsed

try {
  parsed = JSON.parse(cleaned)
} catch (err) {
  console.error("Parse error:", cleaned)
  parsed = { error: "Parse failed", raw: cleaned }
}

// 🔥 NEW: upgrade drinks → include idDrink
let upgradedDrinks = []

if (parsed?.drinks && Array.isArray(parsed.drinks)) {
  upgradedDrinks = await Promise.all(
    parsed.drinks.map(async (name: string) => {
      try {
        const res = await fetch(
          `https://www.thecocktaildb.com/api/json/v1/1/search.php?s=${encodeURIComponent(name)}`
        )
        const data = await res.json()
        return data.drinks?.[0] || null
      } catch {
        return null
      }
    })
  )
}

// remove nulls
upgradedDrinks = upgradedDrinks.filter(Boolean)

// 🔥 return upgraded structure
return NextResponse.json({
  ...parsed,
  drinks: upgradedDrinks
})

  } catch (error) {
    console.error(error)
    return NextResponse.json({ error: "AI failed" }, { status: 500 })
  }
}
