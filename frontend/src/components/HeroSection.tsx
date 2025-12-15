import React from 'react';

interface HeroSectionProps {
  backgroundImage: string;
  title: string;
  subtitle: string;
}

const HeroSection: React.FC<HeroSectionProps> = ({ backgroundImage, title, subtitle }) => {
  return (
    <section className="relative h-[70vh] md:h-[85vh] overflow-hidden">
      <div 
        className="absolute inset-0 bg-cover bg-center"
        style={{ backgroundImage: `url(${backgroundImage})` }}
      >
        <div className="absolute inset-0 bg-black bg-opacity-30" />
      </div>
      
      <div className="relative h-full flex items-center justify-center text-white">
        <div className="text-center px-4">
          <h1 className="text-5xl md:text-7xl font-light tracking-wider mb-4 uppercase">
            {title}
          </h1>
          <p className="text-lg md:text-xl max-w-2xl mx-auto mb-8">
            {subtitle}
          </p>
          <div className="flex flex-col sm:flex-row gap-4 justify-center items-center mt-8">
            <button className="bg-white text-espresso-black px-8 py-3 uppercase tracking-extra-wide text-xs font-medium hover:bg-espresso-cream transition-colors">
              Activate Windows
            </button>
            <span className="text-sm">Go to Settings to activate Windows</span>
          </div>
        </div>
      </div>
    </section>
  );
};

export default HeroSection;
