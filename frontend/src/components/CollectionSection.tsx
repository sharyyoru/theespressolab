import React from 'react';

interface Collection {
  id: string;
  title: string;
  description: string;
  image: string;
  link: string;
}

const CollectionSection: React.FC = () => {
  const collections: Collection[] = [
    {
      id: '1',
      title: 'SIGNATURE COLLECTION',
      description: "THE ESPRESSO LAB'S DEFINING ROASTS",
      image: '/images/signature-collection.jpg',
      link: '/collections/signature',
    },
  ];

  return (
    <section className="bg-gray-800 text-white py-16">
      <div className="container-espresso">
        <div className="text-center mb-12">
          <h2 className="text-3xl md:text-4xl font-light tracking-wider uppercase mb-4">
            DISCOVER OUR CURATED COLLECTIONS
          </h2>
          <p className="text-sm md:text-base max-w-3xl mx-auto">
            From signature beans to rare auction lots — explore coffee in every form, crafted for every experience.
          </p>
        </div>

        <div className="grid md:grid-cols-2 gap-8 items-center">
          <div className="space-y-6">
            <div className="border-t border-white pt-4">
              <h3 className="text-2xl font-light tracking-wider uppercase mb-4">
                {collections[0].title}
              </h3>
              <p className="text-sm mb-6">{collections[0].description}</p>
              <p className="text-sm leading-relaxed mb-6">
                Experience our core collection, perfected through years of sourcing and roasting mastery.
              </p>
            </div>
          </div>

          <div className="grid grid-cols-2 gap-6">
            <img
              src="/images/collection-1.jpg"
              alt="Collection product 1"
              className="w-full aspect-[3/4] object-cover"
            />
            <img
              src="/images/collection-2.jpg"
              alt="Collection product 2"
              className="w-full aspect-[3/4] object-cover"
            />
          </div>
        </div>
      </div>
    </section>
  );
};

export default CollectionSection;
