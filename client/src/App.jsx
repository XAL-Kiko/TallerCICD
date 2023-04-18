import { useEffect, useState } from 'react'
import reactLogo from './assets/react.svg'
import viteLogo from '/vite.svg'
import './App.css'
import { getUrlsVOD } from './graphql/queries'
import { runQuery } from './utils/common'

function App() {
  const [count, setCount] = useState(0)
  const [urls, setUrls] = useState([])

  useEffect(() => {
    const callAPI = async () => {
      const data = await runQuery(getUrlsVOD, { organizationId: "XALDIGITAL" })
      setUrls(data.data.getUrlsVOD)
    }

    callAPI()
  }, []);


  return (
    <div className="App">
      <div>
        { urls.length > 0 
         ? urls.map((item, index) => {
          return <h1 key={index}>{item.filename}</h1>
          })
         : null }

        <a href="https://vitejs.dev" target="_blank">
          <img src={viteLogo} className="logo" alt="Vite logo" />
        </a>
        <a href="https://reactjs.org" target="_blank">
          <img src={reactLogo} className="logo react" alt="React logo" />
        </a>
      </div>
      <h1>Vite + React</h1>
      <div className="card">
        <button onClick={() => setCount((count) => count + 1)}>
          count is {count}
        </button>
        <p>
          Edit <code>src/App.jsx</code> and save to test HMR
        </p>
      </div>
      <p className="read-the-docs">
        Click on the Vite and React logos to learn more
      </p>
    </div>
  )
}

export default App
