"use client"

import { useState, useRef, useEffect } from "react"
import CategoriesDropdown from "@/components/CategoriesDropdown"
import { CATEGORIES } from "@/lib/categories"

// ✅ Next.js navigation
import { useRouter, usePathname } from "next/navigation"
import Link from "next/link"

// ✅ Components (adjust paths if needed)
import SearchBar from "./SearchBar"
import GenieHero from "./components/GenieHero"
import DrinkCard from "./components/DrinkCard"
import Footer from "./components/Footer"

const alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ".split("");

export default function NewHomePage() {
  const router = useRouter();
  const [query, setQuery] = useState("margarita");
  const [drinks, setDrinks] = useState<any[]>([]);
  const [isMagic, setIsMagic] = useState(false);
  
  const [open, setOpen] = useState(false)
  const [selected, setSelected] = useState(null)

  const btnRef = useRef<HTMLButtonElement>(null)

  const pathname = usePathname(); // 👈 HERE

const handleSurprise = async () => {
  setIsMagic(true);

  const res = await fetch(
    "https://www.thecocktaildb.com/api/json/v1/1/random.php"
  );

  const data = await res.json();
  const drink = data.drinks?.[0];

  setTimeout(() => {
    setDrinks(drink ? [drink] : []);
    setIsMagic(false);
  }, 500);
};

const [selectedLetter, setSelectedLetter] = useState<string | null>(null);

const handleLetterSearch = async (letter: string) => {
  setSelectedLetter(letter);

  const res = await fetch(
    `https://www.thecocktaildb.com/api/json/v1/1/search.php?f=${letter}`
  );
  const data = await res.json();
  setDrinks(data.drinks || []);
};
  // 🔥 Fetch drinks
  const fetchDrinks = async (search: string) => {
    const res = await fetch(
      `https://www.thecocktaildb.com/api/json/v1/1/search.php?s=${search}`
    );
    const data = await res.json();
    setDrinks(data.drinks || []);
  };

  // 🔥 Initial load + search trigger
  useEffect(() => {
    fetchDrinks(query);
  }, [query]);

  // 🔍 Search handler
  const handleSearch = (searchText: string) => {
    setQuery(searchText);
  };

 // 👇 ADD THIS RIGHT AFTER handleSearch
  useEffect(() => {
    if (pathname === "/") {
      setSelectedLetter(null);
      setQuery("margarita");
      setIsMagic(false);
    }
  }, [pathname]);

const resetHome = () => {
  setSelectedLetter(null);
  setQuery("margarita");
  setIsMagic(false);
};

const featureBtn = {
  padding: "14px 20px",
  borderRadius: "14px",
  border: "1px solid rgba(0,255,255,0.4)",
  background: "linear-gradient(135deg,#1a0033,#00ffff22)",
  color: "#00ffff",
  cursor: "pointer",
  fontSize: "13px",
  transition: "0.2s",
  backdropFilter: "blur(6px)",
};

  return (
    <div
      style={{
        paddingTop: "60px",
        paddingBottom: "140px",
        display: "flex",
        flexDirection: "column",
        alignItems: "center",
        gap: "30px",
      }}
    >
      {/* 🧞 Genie */}
      <GenieHero magic={isMagic} />

      {/* 🔎 Search */}
<div style={{ marginTop: "-50px" }}>
  <SearchBar onSearch={handleSearch} />
</div>

{/* 🔤 Alphabet Filter */}
<div
  style={{
    display: "flex",
    flexWrap: "wrap",
    justifyContent: "center",
    gap: "8px",
    maxWidth: "800px",
  }}
>
{alphabet.map((letter) => (
<button
  key={letter}
  onClick={() => handleLetterSearch(letter)}

  onMouseEnter={(e) => {
    if (selectedLetter !== letter) {
      e.currentTarget.style.background = "rgba(0,255,255,0.2)";
    }
  }}
  onMouseLeave={(e) => {
    if (selectedLetter !== letter) {
      e.currentTarget.style.background = "transparent";
    }
  }}

  style={{
    padding: "6px 10px",
    borderRadius: "6px",
    border: "1px solid #00ffff",
    background:
      selectedLetter === letter ? "#00ffff" : "transparent",
    color: selectedLetter === letter ? "#000" : "#00ffff",
    cursor: "pointer",
    fontSize: "12px",
  }}
>

      {letter}
    </button>
  ))}
</div>

{/* ⚡ Feature Buttons */}
<div
  style={{
    display: "flex",
    flexDirection: "column",
    alignItems: "center",
    gap: "14px",
    marginTop: "16px",
  }}
>

  {/* 🔹 TOP ROW (3 buttons) */}
  <div
    style={{
      display: "flex",
      gap: "12px",
      justifyContent: "center",
      flexWrap: "wrap",
    }}
  >

<button
  style={featureBtn}
  onClick={() => router.push("/surprise")}

  onMouseEnter={(e) => {
    e.currentTarget.style.background = "rgba(0,255,255,0.2)"
  }}
  onMouseLeave={(e) => {
    e.currentTarget.style.background =
      "linear-gradient(135deg,#1a0033,#00ffff22)"
  }}

>
  🎲 Surprise Me
</button>

<button
  ref={btnRef}
  style={featureBtn}
  onClick={() => setOpen(!open)}   
onMouseEnter={(e) => {
    e.currentTarget.style.background = "rgba(0,255,255,0.2)"
  }}
  onMouseLeave={(e) => {
    e.currentTarget.style.background =
      "linear-gradient(135deg,#1a0033,#00ffff22)"
  }}
>
  📂 Categories
</button>

<CategoriesDropdown
  anchorRef={btnRef}
  open={open}
  categories={CATEGORIES}
  selectedCategory={selected}
  onSelect={(id) => {
    setSelected(id)
    setOpen(false)
    router.push(`/categories/${id}`) // 👉 navigation happens HERE now
  }}
  onClose={() => setOpen(false)}
/>

<button
  style={featureBtn}
  onClick={() => router.push("/genie-ai")}
onMouseEnter={(e) => {
    e.currentTarget.style.background = "rgba(0,255,255,0.2)"
  }}
  onMouseLeave={(e) => {
    e.currentTarget.style.background =
      "linear-gradient(135deg,#1a0033,#00ffff22)"
  }}
>
  🤖 Genie AI
</button>

  </div>

  {/* 🔹 BOTTOM ROW (2 buttons) */}
  <div
    style={{
      display: "flex",
      gap: "12px",
    }}
  >

<button
  style={featureBtn}
  onClick={() => router.push("/fun-facts")}
onMouseEnter={(e) => {
    e.currentTarget.style.background = "rgba(0,255,255,0.2)"
  }}
  onMouseLeave={(e) => {
    e.currentTarget.style.background =
      "linear-gradient(135deg,#1a0033,#00ffff22)"
  }}
>
  🧞 Genie Tales
</button>

<button
  style={featureBtn}
  onClick={() => router.push("/last-set")}
onMouseEnter={(e) => {
    e.currentTarget.style.background = "rgba(0,255,255,0.2)"
  }}
  onMouseLeave={(e) => {
    e.currentTarget.style.background =
      "linear-gradient(135deg,#1a0033,#00ffff22)"
  }}
>
  🧰 Cocktail Kit
</button>

  </div>

</div>

      {/* 🍸 Drinks Grid */}
      <div
        style={{
          display: "grid",
          gridTemplateColumns: "repeat(auto-fit, minmax(250px, 1fr))",
          gap: "20px",
          width: "90%",
          maxWidth: "1200px",
          marginTop: "20px",
        }}
      >
        {drinks.map((drink) => (
          <DrinkCard key={drink.idDrink} drink={drink} />
        ))}
      </div>
      <div style={{ marginTop: "40px" }}>
      <Footer />
      </div>
    </div>
  );
}
