"use client";

import React, { useState, useRef, useEffect } from "react";

interface SearchBarProps {
  onSearch: (query: string) => void;
}

export default function SearchBar({ onSearch }: SearchBarProps) {
  const [text, setText] = useState("");
  const [suggestions, setSuggestions] = useState<any[]>([]);
  const [showDropdown, setShowDropdown] = useState(false);

  const [activeIndex, setActiveIndex] = useState(0);
  const wrapperRef = useRef<HTMLDivElement>(null);

  const handleSearch = () => {
    onSearch(text);
    setShowDropdown(false);
  };

useEffect(() => {
  function handleClickOutside(event: MouseEvent) {
    if (
      wrapperRef.current &&
      !wrapperRef.current.contains(event.target as Node)
    ) {
      setShowDropdown(false);
    }
  }

  document.addEventListener("mousedown", handleClickOutside);

  return () => {
    document.removeEventListener("mousedown", handleClickOutside);
  };
}, []);

  return (
    <div style={{ display: "flex", justifyContent: "center", gap: "10px" }}>
      
      {/* INPUT WRAPPER (IMPORTANT) */}
      <div ref={wrapperRef} style={{ position: "relative" }}>
        
        <input
          value={text}
          placeholder="Search cocktails..."
          
onKeyDown={(e) => {
  if (!showDropdown) return;

  if (e.key === "ArrowDown") {
    e.preventDefault();
    setActiveIndex((prev) =>
      prev < suggestions.length - 1 ? prev + 1 : 0
    );
  }

  if (e.key === "ArrowUp") {
    e.preventDefault();
    setActiveIndex((prev) =>
      prev > 0 ? prev - 1 : suggestions.length - 1
    );
  }

  if (e.key === "Enter") {
    e.preventDefault();

    if (suggestions.length > 0) {
      const selected = suggestions[activeIndex];
      setText(selected.strDrink);
      onSearch(selected.strDrink);
      setShowDropdown(false);
    } else {
      handleSearch();
    }
  }
}}
            onChange={async (e) => {
            const value = e.target.value;
            setText(value);
            setActiveIndex(0);

            if (value.length < 2) {
              setSuggestions([]);
              setShowDropdown(false);
              return;
            }

            const res = await fetch(
              `https://www.thecocktaildb.com/api/json/v1/1/search.php?s=${value}`
            );

            const data = await res.json();

            setSuggestions(data.drinks || []);
            setShowDropdown(true);
          }}

          style={{
            padding: "10px",
            borderRadius: "8px",
            border: "1px solid #00ffff",
            backgroundColor: "#111",
            color: "#00ffff",
            width: "250px",
            outline: "none",
          }}
        />

        {/* DROPDOWN */}
        {showDropdown && suggestions.length > 0 && (
          <div
            style={{
              position: "absolute",
              top: "100%",
              left: 0,
              width: "100%",
              background: "rgba(20, 0, 50, 0.95)",
              border: "1px solid rgba(0,255,255,0.4)",
              borderRadius: "10px",
              marginTop: "6px",
              zIndex: 2000,
              maxHeight: "250px",
              overflowY: "auto",
              boxShadow: "0 0 10px rgba(0,255,255,0.2)",
            }}
          >

{suggestions.slice(0, 6).map((drink, index) => {
  return (
    <div
      key={drink.idDrink}
      onClick={() => {
        setText(drink.strDrink);
        onSearch(drink.strDrink);
        setShowDropdown(false);
      }}
      onMouseEnter={(e) => {
      setActiveIndex(index);
      }}
      onMouseLeave={(e) => {
        e.currentTarget.style.background = "transparent";
        e.currentTarget.style.color = "#00ffff";
      }}
      style={{
background:
  index === activeIndex
    ? "rgba(0,255,255,0.2)"
    : index === 0
    ? "rgba(0,255,255,0.1)"
    : "transparent",
        display: "flex",
        alignItems: "center",
        gap: "10px",
        padding: "8px 10px",
        cursor: "pointer",
        borderBottom: "1px solid rgba(255,255,255,0.1)",
        color: "#00ffff",
      }}
    >
      <img
        src={drink.strDrinkThumb}
        alt={drink.strDrink}
        style={{
          width: "40px",
          height: "40px",
          borderRadius: "6px",
          objectFit: "cover",
          border: "1px solid rgba(0,255,255,0.3)",
        }}
        onError={(e) => {
          (e.currentTarget as HTMLImageElement).src = "/placeholder.png";
        }}
      />

      <span>{drink.strDrink}</span>
    </div>
  );
})}
          </div>
        )}
      </div>

      {/* BUTTON */}
      <button
        onClick={handleSearch}
        style={{
          padding: "10px 16px",
          borderRadius: "8px",
          backgroundColor: "#00ffff",
          color: "#000",
          fontWeight: "bold",
          cursor: "pointer",
        }}
      >
        Search
      </button>
    </div>
  );
}
