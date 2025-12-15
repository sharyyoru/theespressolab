import React from 'react';

const AchievementsSection: React.FC = () => {
  const achievements = [
    {
      number: '5x',
      title: 'NATIONAL TITLES',
      description: 'Proudly recognized as champions of craftsmanship and consistency in the national arena.',
    },
    {
      number: '9x',
      title: 'FINALISTS AT WORLD BARISTA CHAMPIONSHIP',
      description: 'Proudly recognized as champions of craftsmanship and consistency in the national arena.',
    },
    {
      number: '8x',
      title: 'INTERNATIONAL EVENTS REPRESENTED',
      description: 'Sharing our pursuit of coffee excellence across continents and cultures.',
    },
  ];

  return (
    <section className="bg-espresso-cream py-20">
      <div className="container-espresso">
        <div className="grid md:grid-cols-2 gap-12 items-center">
          <div>
            <img
              src="/images/champions.jpg"
              alt="Champions"
              className="w-full aspect-[4/3] object-cover"
            />
            <div className="mt-8">
              <p className="text-xs uppercase tracking-extra-wide text-gray-600 mb-4">
                JOIN OUR REOPENING ON 2026
              </p>
              <h2 className="text-3xl md:text-4xl font-light tracking-wider mb-6">
                THE ESPRESSO LAB'S DEFINING ROASTS
              </h2>
              <p className="leading-relaxed mb-6">
                Showcasing our craft at world stages — precision, creativity, and passion in every pour.
              </p>
            </div>
          </div>

          <div className="space-y-12">
            {achievements.map((achievement) => (
              <div key={achievement.number} className="border-t border-espresso-black pt-6">
                <h3 className="text-5xl font-light mb-2">{achievement.number}</h3>
                <h4 className="text-lg uppercase tracking-wide mb-3">{achievement.title}</h4>
                <p className="text-sm text-gray-700">{achievement.description}</p>
              </div>
            ))}
          </div>
        </div>
      </div>
    </section>
  );
};

export default AchievementsSection;
