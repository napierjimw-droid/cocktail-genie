import Link from "next/link";

export default function Footer() {
  return (
    <div
      style={{
        marginTop: 60,
        paddingTop: 20,
        borderTop: "1px solid rgba(255,255,255,0.15)",
        display: "flex",
        flexDirection: "column",
        alignItems: "center",
        textAlign: "center",
        gap: 8,
        fontSize: 14,
        opacity: 13,
        color: "rgba(0,255,255,0.7)"
      }}
    >
      <div>Drink responsibly. 21+ only.</div>

<div
  style={{
    display: "flex",
    flexDirection: "column",   // 👈 THIS is the key
    alignItems: "center",
    gap: "6px",
    marginTop: "10px",
  }}
>
<Link href="/about" className="footer-link">About</Link>
<Link href="/privacy" className="footer-link">Legal</Link>
<Link href="/legal" className="footer-link">Privacy</Link>
<Link href="/age" className="footer-link">Age Policy</Link>
<Link href="/feedback" className="footer-link">Feedback</Link>
<Link href="/contact" className="footer-link">Contact</Link>
<Link href="/refunds" className="footer-link">Refunds</Link>
      </div>

      <div style={{ fontSize: 11, opacity: 0.5 }}>
        © 2026 Cocktail Genie
      </div>
    </div>
  );
}
