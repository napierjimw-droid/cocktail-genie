"use client"

import Link from "next/link"
import { useRef, useState, useEffect } from "react"

export default function GenieAIPage() {
  const videoRef = useRef<HTMLVideoElement | null>(null)
  const canvasRef = useRef<HTMLCanvasElement | null>(null)

  const [stream, setStream] = useState<MediaStream | null>(null)
  const [photos, setPhotos] = useState<string[]>([])
  const [cameraOn, setCameraOn] = useState(false)
  const [results, setResults] = useState<any>(null)

  // Start camera

const startCamera = async () => {
  try {
    const mediaStream = await navigator.mediaDevices.getUserMedia({
      video: true,
      audio: false,
    })

    setStream(mediaStream)
    setCameraOn(true)
  } catch (err) {
    console.error("Camera error:", err)
  }
}

  // Stop camera
  const stopCamera = () => {
    stream?.getTracks().forEach((track) => track.stop())
    setCameraOn(false)
  }

  // Capture image

const capturePhoto = () => {
  if (!videoRef.current || !canvasRef.current) return

  const canvas = canvasRef.current
  const ctx = canvas.getContext("2d")

  canvas.width = videoRef.current.videoWidth
  canvas.height = videoRef.current.videoHeight

  ctx?.drawImage(videoRef.current, 0, 0)

  const imageData = canvas.toDataURL("image/png")

  // 👉 add to array instead of replacing
  setPhotos((prev) => [...prev, imageData])
}

const handleUpload = (e: React.ChangeEvent<HTMLInputElement>) => {
  const files = e.target.files
  if (!files) return

  const newPhotos: string[] = []

  Array.from(files).forEach((file) => {
    const reader = new FileReader()
    reader.onload = () => {
      if (reader.result) {
        setPhotos((prev) => [...prev, reader.result as string])
      }
    }
    reader.readAsDataURL(file)
  })
}


const analyzeImages = async () => {
  const res = await fetch("/api/analyze", {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify({ images: photos }),
  })

  const data = await res.json()
  console.log("AI RESULT:", data)

  setResults(data) // (this will be used in step 3)
}


useEffect(() => {
  if (cameraOn && stream && videoRef.current) {
    videoRef.current.srcObject = stream

    videoRef.current.onloadedmetadata = () => {
      videoRef.current?.play()
    }
  }
}, [cameraOn, stream])

  // Cleanup on unmount
  useEffect(() => {
    return () => {
      stopCamera()
    }
  }, [])

return (
  <div className="flex flex-col items-center justify-center min-h-screen text-white">
    <h1 className="text-2xl mb-4">🍸 Genie AI Camera</h1>

    {!cameraOn && (
      <button
        onClick={startCamera}
        className="bg-blue-500 px-4 py-2 rounded"
      >
        Open Camera
      </button>
    )}

    {cameraOn && (
      <>
        <video
          ref={videoRef}
          autoPlay
          muted
          playsInline
          className="w-full max-w-md rounded-lg mt-4"
        />

        <div className="flex gap-4 mt-4 items-center">
          <button
            onClick={capturePhoto}
            className="bg-green-500 px-4 py-2 rounded"
          >
            Capture
          </button>

          <label className="bg-blue-500 px-4 py-2 rounded cursor-pointer">
            Upload
            <input
              type="file"
              accept="image/*"
              multiple
              onChange={handleUpload}
              className="hidden"
            />
          </label>

          <button
            onClick={stopCamera}
            className="bg-red-500 px-4 py-2 rounded"
          >
            Stop
          </button>
        </div>
      </>
    )}

    {/* Photos */}
    {photos.length > 0 && (
      <div className="mt-6">
        <h2 className="mb-2">Captured Images:</h2>

        <div className="flex gap-2 flex-wrap">
          {photos.map((img, index) => (
            <img
              key={index}
              src={img}
              alt={`capture-${index}`}
              className="w-24 h-24 object-cover rounded"
            />
          ))}
        </div>

        <button
          onClick={() => setPhotos([])}
          className="mt-3 bg-gray-500 px-3 py-1 rounded"
        >
          Clear All
        </button>
      </div>
    )}

    {/* Hidden canvas */}
    <canvas ref={canvasRef} className="hidden" />

    {/* Analyze */}
    {photos.length > 0 && (
      <button
        className="mt-4 bg-purple-600 px-4 py-2 rounded"
        onClick={analyzeImages}
      >
        Analyze Drinks 🍸
      </button>
    )}

       {/* Results */}
       {results && (
       <div className="mt-6 text-center">
       {/* Bottles */}
       <h2 className="text-lg mt-4">Bottles:</h2>
       <ul>
       {results?.bottles?.map((b: string, i: number) => (
       <li key={i}>🍾 {b}</li>
          ))}
       </ul>

        {/* Ingredients */}
        <h2 className="text-lg">Detected Ingredients:</h2>

      
        {/* Drinks */}

<h2 className="text-lg mt-4">Suggested Drinks:</h2>

<ul>
  {results?.drinks?.map((d: any, i: number) => (
    <li key={i}>
      <Link href={`/drink/${d.idDrink}`}>
        <span className="cursor-pointer hover:underline">
          🍸 {d.strDrink}
        </span>
      </Link>
    </li>
  ))}
</ul>

</div>
    )}
{results?.error && (
  <p className="text-red-500 mt-4">
    AI Error: {results.error}
  </p>
)}
  </div>
)
}
