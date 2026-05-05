import "./globals.css"
import BottomNav from "@/components/BottomNav"
import { AppProvider } from "@/components/AppProvider"
import TopControls from "@/components/TopControls"
import { LanguageProvider } from "@/context/LanguageProvider"

export const metadata = {
  title: "Cocktail Genie",
  description: "Discover magical cocktails from another dimension",
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="en">

      {/* ✅ ADD THIS BLOCK */}
      <head>
<link
  href="https://fonts.googleapis.com/css2?family=Marcellus&display=swap"
  rel="stylesheet"
/>
      </head>

      <body>

        <AppProvider>
          <LanguageProvider>

            <TopControls />

            <div style={{ paddingBottom: 120, paddingTop: 48, minHeight: "100vh" }}>
              {children}
            </div>

            <BottomNav />

          </LanguageProvider>
        </AppProvider>

      </body>
    </html>
  )
}
