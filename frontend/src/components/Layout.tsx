import React from 'react'
import { Link } from 'react-router-dom'

interface LayoutProps {
  children: React.ReactNode
}

export const Layout: React.FC<LayoutProps> = ({ children }) => {
  return (
    <div style={{ minHeight: '100vh', display: 'flex', flexDirection: 'column' }}>
      <Header />
      <main style={{ flex: 1 }}>
        {children}
      </main>
      <Footer />
    </div>
  )
}

const Header: React.FC = () => {
  return (
    <header style={{
      background: '#2c3e50',
      color: 'white',
      padding: '1rem 2rem',
      boxShadow: '0 2px 4px rgba(0,0,0,0.1)'
    }}>
      <nav style={{
        maxWidth: '1200px',
        margin: '0 auto',
        display: 'flex',
        justifyContent: 'space-between',
        alignItems: 'center'
      }}>
        <Link to="/" style={{ 
          color: 'white', 
          textDecoration: 'none',
          fontSize: '1.5rem',
          fontWeight: 'bold'
        }}>
          ☕ THE ESPRESSO LAB
        </Link>
        <div style={{ display: 'flex', gap: '2rem' }}>
          <Link to="/" style={navLinkStyle}>Home</Link>
          <Link to="/products" style={navLinkStyle}>Products</Link>
          <Link to="/courses" style={navLinkStyle}>Courses</Link>
          <Link to="/wholesale" style={navLinkStyle}>Wholesale</Link>
          <Link to="/about" style={navLinkStyle}>About</Link>
          <Link to="/contact" style={navLinkStyle}>Contact</Link>
        </div>
      </nav>
    </header>
  )
}

const Footer: React.FC = () => {
  return (
    <footer style={{
      background: '#34495e',
      color: 'white',
      padding: '2rem',
      marginTop: '4rem'
    }}>
      <div style={{
        maxWidth: '1200px',
        margin: '0 auto',
        display: 'grid',
        gridTemplateColumns: 'repeat(auto-fit, minmax(250px, 1fr))',
        gap: '2rem'
      }}>
        <div>
          <h3 style={{ marginBottom: '1rem' }}>The Espresso Lab</h3>
          <p style={{ color: '#bdc3c7', lineHeight: '1.6' }}>
            Premium specialty coffee and equipment for coffee enthusiasts and professionals.
          </p>
        </div>
        <div>
          <h4 style={{ marginBottom: '1rem' }}>Quick Links</h4>
          <ul style={{ listStyle: 'none', padding: 0 }}>
            <li style={{ marginBottom: '0.5rem' }}>
              <Link to="/products" style={footerLinkStyle}>Products</Link>
            </li>
            <li style={{ marginBottom: '0.5rem' }}>
              <Link to="/courses" style={footerLinkStyle}>Courses</Link>
            </li>
            <li style={{ marginBottom: '0.5rem' }}>
              <Link to="/wholesale" style={footerLinkStyle}>Wholesale</Link>
            </li>
            <li style={{ marginBottom: '0.5rem' }}>
              <Link to="/blog" style={footerLinkStyle}>Blog</Link>
            </li>
          </ul>
        </div>
        <div>
          <h4 style={{ marginBottom: '1rem' }}>Contact</h4>
          <p style={{ color: '#bdc3c7', lineHeight: '1.6' }}>
            Email: info@espressolab.com<br />
            Phone: +1 (555) 123-4567<br />
            Support: support@espressolab.com
          </p>
        </div>
      </div>
      <div style={{
        maxWidth: '1200px',
        margin: '2rem auto 0',
        paddingTop: '2rem',
        borderTop: '1px solid #7f8c8d',
        textAlign: 'center',
        color: '#bdc3c7'
      }}>
        <p>&copy; 2024 The Espresso Lab. All rights reserved.</p>
      </div>
    </footer>
  )
}

const navLinkStyle: React.CSSProperties = {
  color: 'white',
  textDecoration: 'none',
  fontSize: '1rem',
  transition: 'opacity 0.2s'
}

const footerLinkStyle: React.CSSProperties = {
  color: '#bdc3c7',
  textDecoration: 'none'
}
