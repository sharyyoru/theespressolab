import React from 'react';

const StorySection: React.FC = () => {
  return (
    <section className="bg-espresso-cream py-20">
      <div className="container-espresso">
        <div className="grid md:grid-cols-2 gap-12 items-center">
          <div className="grid grid-cols-2 gap-4">
            <img
              src="/images/latte-art.jpg"
              alt="Latte Art"
              className="w-full aspect-square object-cover"
            />
            <div className="flex items-center justify-center bg-white rounded-full aspect-square">
              <div className="text-center p-8">
                <h3 className="text-4xl font-light mb-2">OUR STORY</h3>
              </div>
            </div>
            <div className="col-span-2">
              <img
                src="/images/coffee-beans.jpg"
                alt="Coffee Beans"
                className="w-full aspect-[2/1] object-cover"
              />
            </div>
          </div>

          <div className="space-y-6">
            <p className="text-lg leading-relaxed">
              From beans to brew, every cup tells a tale of passion, craftsmanship, and the journey from remote farms to your neighborhood cafe.
            </p>
            <p className="leading-relaxed">
              Discover our commitment, quality, sustainable practices, and the rich heritage behind your daily ritual.
            </p>
          </div>
        </div>
      </div>
    </section>
  );
};

export default StorySection;
