"use client";

import Link from "next/link";
import { usePathname } from "next/navigation";
import { useState } from "react";
import { useLanguage } from "@/context/LanguageProvider";

export default function BottomNav() {
  const pathname = usePathname();
  const { t } = useLanguage();
  const [pressed, setPressed] = useState<string | null>(null);

  const items = [
    { id: "/", label: "Home", icon: "🏠" },
    { id: "/favorites", label: "Favorites", icon: "❤️" },
    { id: "/top", label: "Top Rated", icon: "⭐" },
  ];

  return (
    <div
      style={{
        position: "fixed",
        bottom: 20,
        left: "50%",
        transform: "translateX(-50%)",
        background: "rgba(20,0,40,0.7)",
        backdropFilter: "blur(16px)",
        border: "1px solid rgba(0,255,255,0.25)",
        borderRadius: 30,
        padding: "12px 24px",
        display: "flex",
        gap: 40,
        zIndex: 1000,
      }}
    >
      {items.map((item) => {
        const active =
          pathname === item.id ||
          (item.id !== "/" && pathname.startsWith(item.id));

        return (
          <Link
            key={item.id}
            href={item.id}

onClick={() => {
  setPressed(item.id);

  // 🔥 FORCE reset if already on home
  if (item.id === "/" && pathname === "/") {
    window.location.reload();
  }

  setTimeout(() => setPressed(null), 120);
}}

            style={{ textDecoration: "none" }}
          >
            <div
              style={{
                display: "flex",
                flexDirection: "column",
                alignItems: "center",
                cursor: "pointer",
                transition: "0.25s",
                transform:
                  pressed === item.id
                    ? "scale(0.8)"
                    : active
                    ? "scale(1.2)"
                    : "scale(1)",
                filter: active
                  ? "drop-shadow(0 0 12px cyan)"
                  : "none",
                opacity: active ? 1 : 0.6,
              }}
            >
              <div style={{ fontSize: 26 }}>{item.icon}</div>

              <div
                style={{
                  fontSize: 14,
                  color: active ? "#00ffff" : "#777",
                  marginTop: 2,
                  letterSpacing: 1,
                }}
              >
                {t(item.label)}
              </div>
            </div>
          </Link>
        );
      })}
    </div>
  );
}
