import React, { useState } from 'react';
import { ChevronLeft, ChevronRight, Heart } from 'lucide-react';

interface Product {
  id: string;
  name: string;
  price: number;
  currency: string;
  image: string;
  category?: string;
}

interface ProductCarouselProps {
  products: Product[];
  title?: string;
}

const ProductCarousel: React.FC<ProductCarouselProps> = ({ products, title }) => {
  const [currentIndex, setCurrentIndex] = useState(0);

  const itemsPerView = {
    mobile: 1,
    tablet: 2,
    desktop: 3,
  };

  const scroll = (direction: 'left' | 'right') => {
    if (direction === 'left') {
      setCurrentIndex(Math.max(0, currentIndex - 1));
    } else {
      setCurrentIndex(Math.min(products.length - itemsPerView.desktop, currentIndex + 1));
    }
  };

  return (
    <div className="py-12">
      {title && (
        <h2 className="text-center text-3xl md:text-4xl font-light tracking-wider uppercase mb-8">
          {title}
        </h2>
      )}
      
      <div className="relative">
        {/* Navigation Buttons */}
        <button
          onClick={() => scroll('left')}
          disabled={currentIndex === 0}
          className="absolute left-0 top-1/2 -translate-y-1/2 z-10 bg-white rounded-full p-3 shadow-lg disabled:opacity-50 hover:bg-espresso-cream transition-colors"
        >
          <ChevronLeft size={24} />
        </button>
        
        <button
          onClick={() => scroll('right')}
          disabled={currentIndex >= products.length - itemsPerView.desktop}
          className="absolute right-0 top-1/2 -translate-y-1/2 z-10 bg-white rounded-full p-3 shadow-lg disabled:opacity-50 hover:bg-espresso-cream transition-colors"
        >
          <ChevronRight size={24} />
        </button>

        {/* Products Grid */}
        <div className="overflow-hidden px-12">
          <div
            className="flex transition-transform duration-500 ease-out"
            style={{ transform: `translateX(-${currentIndex * (100 / itemsPerView.desktop)}%)` }}
          >
            {products.map((product) => (
              <div
                key={product.id}
                className="flex-shrink-0 w-full md:w-1/2 lg:w-1/3 px-4"
              >
                <ProductCard product={product} />
              </div>
            ))}
          </div>
        </div>
      </div>
    </div>
  );
};

const ProductCard: React.FC<{ product: Product }> = ({ product }) => {
  const [isWishlisted, setIsWishlisted] = useState(false);

  return (
    <div className="group relative">
      <div className="relative aspect-square mb-4 overflow-hidden bg-gray-100">
        <img
          src={product.image}
          alt={product.name}
          className="w-full h-full object-cover group-hover:scale-105 transition-transform duration-300"
        />
        <button
          onClick={() => setIsWishlisted(!isWishlisted)}
          className="absolute top-4 right-4 bg-white rounded-full p-2 shadow-md hover:bg-espresso-cream transition-colors"
        >
          <Heart
            size={20}
            className={isWishlisted ? 'fill-espresso-orange text-espresso-orange' : ''}
          />
        </button>
      </div>
      
      {product.category && (
        <p className="text-xs uppercase tracking-wider text-gray-500 mb-2">
          {product.category}
        </p>
      )}
      
      <h3 className="text-sm font-medium mb-2 uppercase tracking-wide">
        {product.name}
      </h3>
      
      <div className="flex items-center justify-between mb-4">
        <p className="text-lg font-medium">
          {product.currency} {product.price.toFixed(2)}
        </p>
      </div>
      
      <button className="w-full btn-primary">
        BUY NOW
      </button>
    </div>
  );
};

export default ProductCarousel;
