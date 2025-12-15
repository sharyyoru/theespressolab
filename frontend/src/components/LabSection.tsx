import React from 'react';

interface NewsItem {
  id: string;
  title: string;
  date: string;
  excerpt: string;
  image: string;
  tag: string;
}

const LabSection: React.FC = () => {
  const news: NewsItem[] = [
    {
      id: '1',
      title: "THE ESPRESSO LAB'S TRIUMPHANT 2024 AUCTION SEASON",
      date: 'November 9, 2024',
      excerpt: 'We Are Thrilled To Announce Our Successful Acquisitions From Three Of The Most Prestigious Coffee Auctions.',
      image: '/images/news-1.jpg',
      tag: 'NEWS',
    },
    {
      id: '2',
      title: "THE ESPRESSO LAB'S TRIUMPHANT 2024 AUCTION SEASON",
      date: 'November 9, 2024',
      excerpt: 'We Are Thrilled To Announce Our Successful Acquisitions From Three Of The Most Prestigious Coffee Auctions.',
      image: '/images/news-2.jpg',
      tag: 'NEWS',
    },
    {
      id: '3',
      title: "THE ESPRESSO LAB'S TRIUMPHANT 2024 AUCTION SEASON",
      date: 'November 9, 2024',
      excerpt: 'We Are Thrilled To Announce Our Successful Acquisitions From Three Of The Most Prestigious Coffee Auctions.',
      image: '/images/news-3.jpg',
      tag: 'NEWS',
    },
    {
      id: '4',
      title: "THE ESPRESSO LAB'S TRIUMPHANT 2024 AUCTION SEASON",
      date: 'November 9, 2024',
      excerpt: 'We Are Thrilled To Announce Our Successful Acquisitions From Three Of The Most Prestigious Coffee Auctions.',
      image: '/images/news-4.jpg',
      tag: 'NEWS',
    },
  ];

  return (
    <section className="bg-white py-20">
      <div className="container-espresso">
        <div className="text-center mb-12">
          <h2 className="text-3xl md:text-4xl font-light tracking-wider uppercase mb-4">
            OUR LAB
          </h2>
          <p className="text-sm md:text-base max-w-2xl mx-auto mb-8">
            News, updates, and insights that bring you closer to the craft and culture of specialty coffee.
          </p>
          <button className="btn-secondary">
            EXPLORE OUR LAB
          </button>
        </div>

        <div className="grid md:grid-cols-2 lg:grid-cols-4 gap-6 mt-12">
          {news.map((item) => (
            <div key={item.id} className="group cursor-pointer">
              <div className="relative aspect-[3/4] overflow-hidden mb-4">
                <img
                  src={item.image}
                  alt={item.title}
                  className="w-full h-full object-cover group-hover:scale-105 transition-transform duration-300"
                />
                <span className="absolute top-4 left-4 bg-white px-3 py-1 text-xs uppercase tracking-wider">
                  {item.tag}
                </span>
              </div>
              <p className="text-xs text-gray-500 mb-2">{item.date}</p>
              <h3 className="text-sm font-medium uppercase tracking-wide mb-2 line-clamp-2">
                {item.title}
              </h3>
              <p className="text-xs text-gray-600 line-clamp-2">{item.excerpt}</p>
            </div>
          ))}
        </div>
      </div>
    </section>
  );
};

export default LabSection;
