import React from 'react';

const FarmSection: React.FC = () => {
  return (
    <section className="relative h-[70vh] overflow-hidden">
      <div 
        className="absolute inset-0 bg-cover bg-center"
        style={{ backgroundImage: 'url(/images/farm-landscape.jpg)' }}
      >
        <div className="absolute inset-0 bg-black bg-opacity-40" />
      </div>
      
      <div className="relative h-full flex items-center">
        <div className="container-espresso">
          <div className="max-w-2xl text-white">
            <p className="text-sm uppercase tracking-extra-wide mb-4">FROM FARM TO CUP</p>
            <h2 className="text-4xl md:text-5xl font-light tracking-wider mb-6">
              FincaRasha
            </h2>
            <p className="text-lg mb-4 leading-relaxed">
              From seed to cup, every journey begins at the source.
            </p>
            <p className="mb-8 leading-relaxed">
              We partner with pioneering farms across the world — from Brazil's highlands to Ethiopia's lush valleys — where families and communities nurture coffee with generations of expertise. Through direct relationships we ensure that every bean we roast carries a story of sustainability, craftsmanship, and passion.
            </p>
            <button className="btn-secondary bg-transparent border-white text-white hover:bg-white hover:text-espresso-black">
              LEARN MORE ON OUR FARM
            </button>
          </div>
        </div>
      </div>
    </section>
  );
};

export default FarmSection;
