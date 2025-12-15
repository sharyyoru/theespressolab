import React from 'react'
import { Link } from 'react-router-dom'

export const Home: React.FC = () => {
  return (
    <div>
      {/* Hero Section */}
      <section style={{
        background: 'linear-gradient(135deg, #2c3e50 0%, #34495e 100%)',
        color: 'white',
        padding: '6rem 2rem',
        textAlign: 'center'
      }}>
        <div style={{ maxWidth: '800px', margin: '0 auto' }}>
          <h1 style={{ fontSize: '3rem', marginBottom: '1rem', fontWeight: 'bold' }}>
            Welcome to The Espresso Lab
          </h1>
          <p style={{ fontSize: '1.25rem', marginBottom: '2rem', opacity: 0.9 }}>
            Premium specialty coffee and equipment for coffee enthusiasts and professionals
          </p>
          <div style={{ display: 'flex', gap: '1rem', justifyContent: 'center', flexWrap: 'wrap' }}>
            <Link to="/products" style={buttonStyle}>
              Shop Products
            </Link>
            <Link to="/courses" style={{ ...buttonStyle, background: 'transparent', border: '2px solid white' }}>
              Browse Courses
            </Link>
          </div>
        </div>
      </section>

      {/* Features Section */}
      <section style={{ padding: '4rem 2rem', maxWidth: '1200px', margin: '0 auto' }}>
        <h2 style={{ textAlign: 'center', fontSize: '2.5rem', marginBottom: '3rem', color: '#2c3e50' }}>
          Why Choose Us
        </h2>
        <div style={{
          display: 'grid',
          gridTemplateColumns: 'repeat(auto-fit, minmax(280px, 1fr))',
          gap: '2rem'
        }}>
          <FeatureCard
            icon="☕"
            title="Premium Coffee"
            description="Carefully selected specialty coffee from the world's finest producers"
          />
          <FeatureCard
            icon="🎓"
            title="Expert Training"
            description="Professional courses taught by certified baristas and coffee experts"
          />
          <FeatureCard
            icon="✓"
            title="Quality Control"
            description="Rigorous QC process ensures every order meets our high standards"
          />
          <FeatureCard
            icon="🏢"
            title="Wholesale Solutions"
            description="Dedicated wholesale portal with exclusive products and pricing"
          />
        </div>
      </section>

      {/* Collections Section */}
      <section style={{ background: '#f8f9fa', padding: '4rem 2rem' }}>
        <div style={{ maxWidth: '1200px', margin: '0 auto' }}>
          <h2 style={{ textAlign: 'center', fontSize: '2.5rem', marginBottom: '3rem', color: '#2c3e50' }}>
            Featured Collections
          </h2>
          <div style={{
            display: 'grid',
            gridTemplateColumns: 'repeat(auto-fit, minmax(300px, 1fr))',
            gap: '2rem'
          }}>
            <CollectionCard
              title="New Arrivals"
              description="Discover our latest coffee selections"
              link="/products?collection=new_arrivals"
            />
            <CollectionCard
              title="Rare Lots"
              description="Exclusive micro-lot coffees"
              link="/products?collection=rare_lots"
            />
            <CollectionCard
              title="Equipment"
              description="Professional coffee equipment"
              link="/products?collection=specialty_gadgets"
            />
          </div>
        </div>
      </section>

      {/* CTA Section */}
      <section style={{
        padding: '4rem 2rem',
        textAlign: 'center',
        maxWidth: '800px',
        margin: '0 auto'
      }}>
        <h2 style={{ fontSize: '2.5rem', marginBottom: '1rem', color: '#2c3e50' }}>
          Ready to Start Your Coffee Journey?
        </h2>
        <p style={{ fontSize: '1.125rem', marginBottom: '2rem', color: '#7f8c8d' }}>
          Join thousands of coffee lovers who trust The Espresso Lab for their coffee needs
        </p>
        <Link to="/products" style={buttonStyle}>
          Explore Products
        </Link>
      </section>
    </div>
  )
}

interface FeatureCardProps {
  icon: string
  title: string
  description: string
}

const FeatureCard: React.FC<FeatureCardProps> = ({ icon, title, description }) => {
  return (
    <div style={{
      padding: '2rem',
      textAlign: 'center',
      background: 'white',
      borderRadius: '8px',
      boxShadow: '0 2px 8px rgba(0,0,0,0.1)',
      transition: 'transform 0.2s'
    }}>
      <div style={{ fontSize: '3rem', marginBottom: '1rem' }}>{icon}</div>
      <h3 style={{ fontSize: '1.5rem', marginBottom: '0.5rem', color: '#2c3e50' }}>{title}</h3>
      <p style={{ color: '#7f8c8d', lineHeight: '1.6' }}>{description}</p>
    </div>
  )
}

interface CollectionCardProps {
  title: string
  description: string
  link: string
}

const CollectionCard: React.FC<CollectionCardProps> = ({ title, description, link }) => {
  return (
    <Link to={link} style={{ textDecoration: 'none' }}>
      <div style={{
        padding: '3rem 2rem',
        background: 'white',
        borderRadius: '8px',
        boxShadow: '0 2px 8px rgba(0,0,0,0.1)',
        transition: 'transform 0.2s, box-shadow 0.2s',
        cursor: 'pointer',
        height: '100%'
      }}>
        <h3 style={{ fontSize: '1.75rem', marginBottom: '0.5rem', color: '#2c3e50' }}>{title}</h3>
        <p style={{ color: '#7f8c8d', lineHeight: '1.6' }}>{description}</p>
        <div style={{ marginTop: '1rem', color: '#3498db', fontWeight: 'bold' }}>
          View Collection →
        </div>
      </div>
    </Link>
  )
}

const buttonStyle: React.CSSProperties = {
  display: 'inline-block',
  padding: '1rem 2rem',
  background: '#3498db',
  color: 'white',
  textDecoration: 'none',
  borderRadius: '5px',
  fontSize: '1.125rem',
  fontWeight: 'bold',
  transition: 'background 0.2s'
}
