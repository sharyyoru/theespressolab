import React, { useState, useEffect } from 'react';
import { Link } from 'react-router-dom';
import { Search, User, Heart, ShoppingCart, Menu, Facebook, Instagram, Youtube } from 'lucide-react';

interface HeaderProps {
  cartCount?: number;
  wishlistCount?: number;
}

const Header: React.FC<HeaderProps> = ({ cartCount = 0, wishlistCount = 0 }) => {
  const [isScrolled, setIsScrolled] = useState(false);
  const [isMobileMenuOpen, setIsMobileMenuOpen] = useState(false);

  useEffect(() => {
    const handleScroll = () => {
      setIsScrolled(window.scrollY > 100);
    };
    window.addEventListener('scroll', handleScroll);
    return () => window.removeEventListener('scroll', handleScroll);
  }, []);

  const navItems = [
    { label: 'SPECIALTY COFFEE', icon: '☕', href: '/specialty-coffee' },
    { label: 'SPECIALTY GADGETS', icon: '🎁', href: '/gadgets' },
    { label: 'INSTANT COFFEE', icon: '📦', href: '/instant-coffee' },
    { label: 'JASMINE CUPS', icon: '☕', href: '/jasmine-cups' },
    { label: 'THE BARISTA DANCE', icon: '💃', href: '/barista-dance' },
  ];

  return (
    <>
      {/* Top Banner */}
      {!isScrolled && (
        <div className="bg-espresso-black text-white py-2 text-center text-xs tracking-wider">
          ☕ TASTE INNOVATION: TRY OUR AWARD WINNING JASMINE CUP—NOW AVAILABLE ONLINE
        </div>
      )}

      {/* Social Bar */}
      {!isScrolled && (
        <div className="bg-white border-b border-gray-200 py-2">
          <div className="container-espresso flex justify-between items-center">
            <div className="flex gap-4 text-sm">
              <a href="https://facebook.com" target="_blank" rel="noopener noreferrer" className="hover:text-espresso-orange transition-colors">
                <Facebook size={16} />
              </a>
              <a href="https://instagram.com" target="_blank" rel="noopener noreferrer" className="hover:text-espresso-orange transition-colors">
                <Instagram size={16} />
              </a>
              <a href="https://youtube.com" target="_blank" rel="noopener noreferrer" className="hover:text-espresso-orange transition-colors">
                <Youtube size={16} />
              </a>
            </div>
            <div className="flex gap-4 text-xs uppercase tracking-wider">
              <select className="bg-transparent border-none text-xs">
                <option>ALL</option>
                <option>AED</option>
                <option>USD</option>
              </select>
            </div>
          </div>
        </div>
      )}

      {/* Main Header */}
      <header
        className={`bg-espresso-cream sticky top-0 z-50 transition-all duration-300 ${
          isScrolled ? 'shadow-md py-3' : 'py-6'
        }`}
      >
        <div className="container-espresso">
          <div className="flex items-center justify-between">
            {/* Logo */}
            <Link to="/" className="flex-shrink-0">
              <img
                src="/logo.png"
                alt="The Espresso Lab"
                className={`transition-all duration-300 ${isScrolled ? 'h-10' : 'h-16'}`}
              />
            </Link>

            {/* Search Bar - Desktop */}
            <div className="hidden md:flex flex-1 max-w-md mx-8">
              <div className="relative w-full">
                <input
                  type="text"
                  placeholder="Search"
                  className="w-full px-4 py-2 border border-gray-300 bg-white focus:outline-none focus:border-espresso-orange"
                />
                <Search className="absolute right-3 top-1/2 -translate-y-1/2 text-gray-400" size={20} />
              </div>
            </div>

            {/* Actions */}
            <div className="flex items-center gap-4">
              <Link to="/account" className="hover:text-espresso-orange transition-colors">
                <User size={22} />
              </Link>
              <Link to="/wishlist" className="relative hover:text-espresso-orange transition-colors">
                <Heart size={22} />
                {wishlistCount > 0 && (
                  <span className="absolute -top-2 -right-2 bg-espresso-orange text-white text-xs rounded-full w-5 h-5 flex items-center justify-center">
                    {wishlistCount}
                  </span>
                )}
              </Link>
              <Link to="/cart" className="relative hover:text-espresso-orange transition-colors">
                <ShoppingCart size={22} />
                {cartCount > 0 && (
                  <span className="absolute -top-2 -right-2 bg-espresso-orange text-white text-xs rounded-full w-5 h-5 flex items-center justify-center">
                    {cartCount}
                  </span>
                )}
              </Link>
              <button
                onClick={() => setIsMobileMenuOpen(!isMobileMenuOpen)}
                className="hover:text-espresso-orange transition-colors"
              >
                <Menu size={24} />
              </button>
            </div>
          </div>
        </div>

        {/* Navigation */}
        <nav className="container-espresso mt-4 border-t border-gray-300 pt-4">
          <div className="hidden lg:flex justify-between items-center text-xs uppercase tracking-extra-wide">
            {navItems.map((item) => (
              <Link
                key={item.label}
                to={item.href}
                className="flex items-center gap-2 hover:text-espresso-orange transition-colors"
              >
                <span>{item.icon}</span>
                <span>{item.label}</span>
              </Link>
            ))}
          </div>
        </nav>
      </header>

      {/* Mobile Menu */}
      {isMobileMenuOpen && (
        <div className="fixed inset-0 bg-black bg-opacity-50 z-40" onClick={() => setIsMobileMenuOpen(false)}>
          <div
            className="fixed right-0 top-0 h-full w-80 bg-white shadow-xl p-6"
            onClick={(e) => e.stopPropagation()}
          >
            <button
              onClick={() => setIsMobileMenuOpen(false)}
              className="absolute top-4 right-4 text-2xl"
            >
              ×
            </button>
            <nav className="mt-12 space-y-4">
              {navItems.map((item) => (
                <Link
                  key={item.label}
                  to={item.href}
                  className="block text-sm uppercase tracking-wider hover:text-espresso-orange transition-colors"
                  onClick={() => setIsMobileMenuOpen(false)}
                >
                  {item.label}
                </Link>
              ))}
            </nav>
          </div>
        </div>
      )}
    </>
  );
};

export default Header;
