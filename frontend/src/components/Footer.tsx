import React from 'react';
import { Link } from 'react-router-dom';

const Footer: React.FC = () => {
  return (
    <footer className="bg-espresso-black text-white py-12">
      <div className="container-espresso">
        <div className="grid md:grid-cols-4 gap-8 mb-12">
          <div>
            <img
              src="/logo-light.png"
              alt="The Espresso Lab"
              className="h-16 mb-6"
            />
          </div>

          <div>
            <h4 className="text-sm uppercase tracking-wider mb-4 font-medium">OUR COMPANY</h4>
            <ul className="space-y-2 text-sm">
              <li><Link to="/story" className="hover:text-espresso-orange transition-colors">Our Story</Link></li>
              <li><Link to="/team" className="hover:text-espresso-orange transition-colors">Meet the Team</Link></li>
              <li><Link to="/profile" className="hover:text-espresso-orange transition-colors">Download Profile</Link></li>
              <li><Link to="/journey" className="hover:text-espresso-orange transition-colors">Our Journey</Link></li>
              <li><Link to="/lab" className="hover:text-espresso-orange transition-colors">The Lab</Link></li>
              <li><Link to="/champions" className="hover:text-espresso-orange transition-colors">The Champions</Link></li>
              <li><Link to="/gahwa" className="hover:text-espresso-orange transition-colors">Gahwa</Link></li>
              <li><Link to="/careers" className="hover:text-espresso-orange transition-colors">Careers</Link></li>
            </ul>
          </div>

          <div>
            <h4 className="text-sm uppercase tracking-wider mb-4 font-medium">OUR PRODUCTS</h4>
            <ul className="space-y-2 text-sm">
              <li><Link to="/new-arrivals" className="hover:text-espresso-orange transition-colors">New Arrivals</Link></li>
              <li><Link to="/coffee" className="hover:text-espresso-orange transition-colors">All Coffee</Link></li>
              <li><Link to="/instant-coffee" className="hover:text-espresso-orange transition-colors">Instant Coffee</Link></li>
              <li><Link to="/drip-bags" className="hover:text-espresso-orange transition-colors">Drip Bags</Link></li>
              <li><Link to="/gadgets" className="hover:text-espresso-orange transition-colors">Specialty Gadgets</Link></li>
              <li><Link to="/jasmine-cup" className="hover:text-espresso-orange transition-colors">JASMINE Cup</Link></li>
            </ul>
          </div>

          <div>
            <h4 className="text-sm uppercase tracking-wider mb-4 font-medium">GET IN TOUCH</h4>
            <ul className="space-y-2 text-sm">
              <li className="flex items-start gap-2">
                <span>📍</span>
                <span>The Espresso Lab</span>
              </li>
              <li className="flex items-start gap-2">
                <span>📞</span>
                <span>+971556568883</span>
              </li>
              <li className="flex items-start gap-2">
                <span>✉️</span>
                <span>webmaster@theespressolab.com</span>
              </li>
            </ul>
            <div className="mt-6">
              <p className="text-xs uppercase tracking-wider mb-2 font-medium">THE ESPRESSO LAB ROASTERY</p>
              <p className="text-xs">L.L.C, Al Quoz Logistics Park, Unit No. S04-104, 13349 Dubai, U.L,</p>
              <p className="text-xs">United Arab Emirates</p>
              <p className="text-xs mt-2">TRN number:</p>
              <p className="text-xs">100044168100003</p>
            </div>
          </div>
        </div>

        <div className="border-t border-gray-700 pt-8 flex flex-col md:flex-row justify-between items-center gap-4">
          <p className="text-xs text-gray-400">© 2024 The Espresso Lab. All rights reserved.</p>
          <div className="flex gap-4">
            <img src="/payment-amex.svg" alt="Amex" className="h-6" />
            <img src="/payment-applepay.svg" alt="Apple Pay" className="h-6" />
            <img src="/payment-mastercard.svg" alt="Mastercard" className="h-6" />
            <img src="/payment-visa.svg" alt="Visa" className="h-6" />
          </div>
        </div>
      </div>
    </footer>
  );
};

export default Footer;
