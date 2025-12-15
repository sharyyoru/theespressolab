import React from 'react';

interface Location {
  id: string;
  name: string;
  address: string;
  description: string;
  image: string;
}

const LocationsSection: React.FC = () => {
  const locations: Location[] = [
    {
      id: '1',
      name: 'DUBAI DESIGN DISTRICT D3',
      address: 'Building 5, Street 4A, Al Quoz Industrial Area 2, Dubai, UAE',
      description: 'Our Al Quoz roastery, Where our D3 & 4 locations are roasted. Visit our Dubai',
      image: '/images/location-d3.jpg',
    },
    {
      id: '2',
      name: 'AL QUOZ',
      address: 'Al Quoz Industrial Area 2, Sheikh Mohammed bin Rashid Boulevard, Dubai, UAE',
      description: 'Our flagship location, delivering exceptional coffee experiences. Visit our lab.',
      image: '/images/location-alquoz.jpg',
    },
    {
      id: '3',
      name: 'ABU DHABI - AL HISN',
      address: 'Al Quoz Industrial Area 2, Hissan Mohammed bin Khalid, Abu Dhabi, UAE',
      description: 'Opened in Abu Dhabi in 2023, bringing our roasting philosophy to the capital city.',
      image: '/images/location-abudhabi.jpg',
    },
    {
      id: '4',
      name: 'NAD AL SHEBA MALL',
      address: 'Nad Al Sheba, Mohammed bin Rashid City, Dubai, UAE',
      description: 'Our Al Sheba location, delivering a unique coffee Shop & our first roastery in the UAE.',
      image: '/images/location-nadal.jpg',
    },
  ];

  return (
    <section className="bg-espresso-cream py-20">
      <div className="container-espresso">
        <div className="text-center mb-12">
          <h2 className="text-3xl md:text-4xl font-light tracking-wider uppercase mb-4">
            EXPERIENCE THE ESPRESSO LAB IN PERSON
          </h2>
          <p className="text-sm md:text-base mb-4">
            From design to atmosphere, every location brings its own character, crafted to give guests a one-of-a-kind experience.
          </p>
          <div className="flex items-center justify-center gap-2 text-2xl mb-8">
            <span>👥 + ☕ + (🍰 × ⭕) = ❤️</span>
          </div>
        </div>

        <div className="grid md:grid-cols-2 lg:grid-cols-4 gap-6">
          {locations.map((location) => (
            <div key={location.id} className="group cursor-pointer">
              <div className="relative aspect-square overflow-hidden mb-4">
                <img
                  src={location.image}
                  alt={location.name}
                  className="w-full h-full object-cover group-hover:scale-105 transition-transform duration-300"
                />
              </div>
              <h3 className="text-sm font-medium uppercase tracking-wide mb-2">
                {location.name}
              </h3>
              <p className="text-xs text-gray-600 mb-2">{location.description}</p>
              <p className="text-xs text-gray-500 line-clamp-2">{location.address}</p>
            </div>
          ))}
        </div>
      </div>
    </section>
  );
};

export default LocationsSection;
