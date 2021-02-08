import './App.css'

import React, { useEffect, useState } from 'react'
import ReactGlobe from 'react-globe'

function App() {
  const [markers, setMarkers] = useState([])
  const [focus, setFocus] = useState()

  useEffect(() => {
    const latitude = 47.1923146
    const longitude = -114.0890228
    const n = 30

    fetch(
      `http://localhost:4567/v1/satellites?n=${n}&latitude=${latitude}&longitude=${longitude}`
    )
      .then(r => r.json())
      .then(data => {
        const satellites = data.map(({ id, latitude, longitude }) => ({
          id: id,
          coordinates: [latitude, longitude],
          color: 'red',
          value: 1
        }))

        satellites.push({
          id: 'origin',
          coordinates: [latitude, longitude],
          color: 'yellow',
          value: 1
        })

        setMarkers(satellites)
        setFocus([latitude, longitude])
      })
  }, [])

  const options = {
    focusDistanceRadiusScale: 3,
    cameraAutoRotateSpeed: 0,
    enableCameraAutoRotate: false,
    enableMarkerGlow: false
  }

  return (
    <div className="App">
      <ReactGlobe markers={markers} focus={focus} options={options} />
    </div>
  )
}

export default App
