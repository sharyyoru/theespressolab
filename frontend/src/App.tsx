import React from 'react'
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom'
import HomePage from './pages/HomePage'

function App() {
  return (
    <Router>
      <Routes>
        <Route path="/" element={<HomePage />} />
        <Route path="/products" element={<PlaceholderPage title="Products" />} />
        <Route path="/courses" element={<PlaceholderPage title="Courses" />} />
        <Route path="/wholesale" element={<PlaceholderPage title="Wholesale" />} />
        <Route path="/about" element={<PlaceholderPage title="About Us" />} />
        <Route path="/contact" element={<PlaceholderPage title="Contact" />} />
        <Route path="/blog" element={<PlaceholderPage title="Blog" />} />
      </Routes>
    </Router>
  )
}

const PlaceholderPage: React.FC<{ title: string }> = ({ title }) => {
  return (
    <div style={{ padding: '4rem 2rem', textAlign: 'center', maxWidth: '800px', margin: '0 auto' }}>
      <h1 style={{ fontSize: '3rem', marginBottom: '1rem', color: '#2c3e50' }}>{title}</h1>
      <p style={{ fontSize: '1.25rem', color: '#7f8c8d' }}>
        This page is under construction. Check back soon!
      </p>
    </div>
  )
}

export default App
