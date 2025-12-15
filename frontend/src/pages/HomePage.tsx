import React from 'react';
import Header from '../components/Header';
import HeroSection from '../components/HeroSection';
import ProductCarousel from '../components/ProductCarousel';
import CollectionSection from '../components/CollectionSection';
import StorySection from '../components/StorySection';
import FarmSection from '../components/FarmSection';
import InstantCoffeeSection from '../components/InstantCoffeeSection';
import OriginSection from '../components/OriginSection';
import AchievementsSection from '../components/AchievementsSection';
import LabSection from '../components/LabSection';
import LocationsSection from '../components/LocationsSection';
import Footer from '../components/Footer';

const HomePage: React.FC = () => {
  const featuredProducts = [
    {
      id: '1',
      name: 'T676 SUDAN RUME SIGNATURE',
      price: 65.00,
      currency: 'AED',
      image: '/images/product-panama.jpg',
      category: 'PANAMA',
    },
    {
      id: '2',
      name: 'T676 SUDAN RUME SIGNATURE',
      price: 65.00,
      currency: 'AED',
      image: '/images/product-signature.jpg',
      category: 'SIGNATURE',
    },
    {
      id: '3',
      name: 'T676 SUDAN RUME SIGNATURE',
      price: 65.00,
      currency: 'AED',
      image: '/images/product-ethiopia.jpg',
      category: 'ETHIOPIA',
    },
  ];

  const bestSellers = [
    {
      id: '4',
      name: 'OLIVE OIL DECAF',
      price: 45.00,
      currency: 'AED',
      image: '/images/bestseller-1.jpg',
    },
    {
      id: '5',
      name: 'OLIVE OIL DECAF',
      price: 45.00,
      currency: 'AED',
      image: '/images/bestseller-2.jpg',
    },
    {
      id: '6',
      name: 'PANAMA',
      price: 65.00,
      currency: 'AED',
      image: '/images/bestseller-3.jpg',
    },
  ];

  return (
    <div className="min-h-screen">
      <Header cartCount={0} wishlistCount={0} />
      
      <main>
        <HeroSection
          backgroundImage="/images/hero-coffee-cup.jpg"
          title="PRECISION IN EVERY POUR"
          subtitle="Where rare beans and design meet the art of coffee."
        />

        <section className="bg-white py-16">
          <div className="container-espresso">
            <div className="text-center mb-8">
              <h2 className="text-3xl md:text-4xl font-light tracking-wider uppercase mb-8">
                ENJOY LIMITED AT HOME
              </h2>
              <div className="flex justify-center gap-8 mb-12 text-xs uppercase tracking-extra-wide">
                <button className="border-b-2 border-espresso-black pb-2">AUCTION LOTS</button>
                <button className="text-gray-400 pb-2 hover:text-espresso-black transition-colors">SIGNATURE LOTS</button>
                <button className="text-gray-400 pb-2 hover:text-espresso-black transition-colors">RARE LOTS</button>
                <button className="text-gray-400 pb-2 hover:text-espresso-black transition-colors">RESERVE LOTS</button>
              </div>
            </div>
            <ProductCarousel products={featuredProducts} />
          </div>
        </section>

        <CollectionSection />
        <StorySection />

        <section className="bg-white py-16">
          <div className="container-espresso">
            <h2 className="text-center text-3xl md:text-4xl font-light tracking-wider uppercase mb-12">
              OUR BEST SELLING COFFEES
            </h2>
            <div className="flex justify-center gap-8 mb-12 text-xs uppercase tracking-extra-wide">
              <button className="border-b-2 border-espresso-black pb-2">SPECIALTY COFFEE</button>
              <button className="text-gray-400 pb-2 hover:text-espresso-black transition-colors">INSTANT COFFEE</button>
              <button className="text-gray-400 pb-2 hover:text-espresso-black transition-colors">DRIP COFFEE</button>
              <button className="text-gray-400 pb-2 hover:text-espresso-black transition-colors">CAPSULE COFFEE</button>
            </div>
            <ProductCarousel products={bestSellers} />
          </div>
        </section>

        <FarmSection />
        <InstantCoffeeSection />
        <OriginSection />
        <AchievementsSection />
        <LabSection />
        <LocationsSection />
      </main>

      <Footer />
    </div>
  );
};

export default HomePage;
