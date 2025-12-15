import React from 'react';

const InstantCoffeeSection: React.FC = () => {
  return (
    <section className="bg-espresso-cream py-20">
      <div className="container-espresso">
        <div className="grid md:grid-cols-2 gap-12 items-center">
          <div className="space-y-6">
            <p className="text-xs uppercase tracking-extra-wide text-gray-600">INSTANT COFFEE</p>
            <h2 className="text-4xl md:text-5xl font-light tracking-wider">
              EL INDIO CATURRA - INSTANT COFFEE
            </h2>
            <p className="text-lg leading-relaxed">
              A smooth, bright instant brew made from premium Caturra beans.
            </p>
            <button className="btn-secondary">
              SHOP INSTANT COFFEE
            </button>
          </div>

          <div className="flex justify-center">
            <img
              src="/images/instant-coffee-box.jpg"
              alt="El Indio Caturra Instant Coffee"
              className="w-full max-w-md object-contain"
            />
          </div>
        </div>
      </div>
    </section>
  );
};

export default InstantCoffeeSection;
