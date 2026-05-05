"use client"

import { createContext, useContext, useEffect, useState } from "react"
import { dictionary } from "@/i18n/dictionary"

type LanguageContextType = {
  lang: string
  setLang: (lang: string) => void
  t: (key: string) => string
}

const LanguageContext = createContext<LanguageContextType | null>(null)

export function LanguageProvider({ children }: { children: React.ReactNode }) {
  const [lang, setLangState] = useState("EN")

  useEffect(() => {
    const saved = localStorage.getItem("cocktail_lang")
    if (saved) setLangState(saved)
  }, [])

  const setLang = (newLang: string) => {
    localStorage.setItem("cocktail_lang", newLang)
    setLangState(newLang)
  }

const t = (key: string) => {
  return dictionary[lang]?.[key] || key
}

  return (
    <LanguageContext.Provider value={{ lang, setLang, t }}>
      {children}
    </LanguageContext.Provider>
  )
}

export function useLanguage() {
  const context = useContext(LanguageContext)
  if (!context) throw new Error("useLanguage must be used inside LanguageProvider")
  return context
}
