import React from 'react';

interface Origin {
  name: string;
  image: string;
}

const OriginSection: React.FC = () => {
  const origins: Origin[] = [
    { name: 'PANAMA', image: '/images/origin-panama.jpg' },
    { name: 'ETHIOPIA', image: '/images/origin-ethiopia.jpg' },
    { name: 'YEMEN', image: '/images/origin-yemen.jpg' },
    { name: 'COLUMBIA', image: '/images/origin-columbia.jpg' },
  ];

  return (
    <section className="bg-white py-16">
      <div className="container-espresso">
        <div className="text-center mb-12">
          <button className="btn-secondary mb-8">
            MEET OUR PRODUCERS
          </button>
        </div>

        <div className="grid grid-cols-2 md:grid-cols-4 gap-6">
          {origins.map((origin) => (
            <div key={origin.name} className="group cursor-pointer">
              <div className="relative aspect-square overflow-hidden mb-3">
                <img
                  src={origin.image}
                  alt={origin.name}
                  className="w-full h-full object-cover group-hover:scale-105 transition-transform duration-300"
                />
                <div className="absolute inset-0 bg-black bg-opacity-20 group-hover:bg-opacity-30 transition-opacity" />
                <div className="absolute bottom-4 left-4 bg-white px-4 py-2">
                  <p className="text-xs font-medium uppercase tracking-wider">{origin.name}</p>
                </div>
              </div>
            </div>
          ))}
        </div>
      </div>
    </section>
  );
};

export default OriginSection;
