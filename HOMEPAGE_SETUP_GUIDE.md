# Espresso Lab Homepage - Setup Guide

## 🎨 Design Implementation

Based on the Figma design, the homepage features:
- **Sticky header** that transforms on scroll
- **Hero section** with full-screen coffee imagery
- **Product carousels** with navigation arrows
- **Content sections**: Collections, Story, Farm, Instant Coffee, Origins, Achievements, Lab, Locations
- **Footer** with company info and payment methods
- **Responsive design** for mobile, tablet, and desktop

## 📋 Step-by-Step Setup

### 1. Run Supabase SQL Commands

Execute these SQL files in order in your Supabase SQL Editor:

```bash
# Database setup (steps 1-10 already completed)
✅ 01_extensions_and_enums.sql
✅ 02_base_tables.sql
✅ 03_dependent_tables.sql
✅ 04_product_relations.sql
✅ 05_cart_and_checkout.sql
✅ 06_qc_and_notifications.sql
✅ 07_indexes.sql (fixed - company_id indexes commented out)
✅ 08_functions_and_triggers.sql
✅ 09_rls_policies.sql
✅ 10_realtime.sql (fixed with conditional logic)

# NEW: Storage buckets and RLS policies
11_storage_buckets.sql
```

**File**: `supabase/11_storage_buckets.sql`

This creates 5 storage buckets:
- `product-images` (public read, admin write)
- `site-assets` (public read, admin write) - for logo, favicon
- `blog-images` (public read, admin write)
- `location-images` (public read, admin write)
- `user-uploads` (private, user-specific folders)

### 2. Setup Sanity CMS

Navigate to Sanity Studio:

```bash
cd sanity
npm install
npm run dev
```

**New Schema Added**: `siteSettings.ts`

Access Sanity Studio at `http://localhost:3333` and configure:

1. **Site Settings** (singleton document):
   - Upload logo (main)
   - Upload logo light version (for dark backgrounds)
   - Upload favicon (32x32px recommended)
   - Set top banner text (English & Arabic)
   - Configure social media URLs
   - Add contact information
   - Set default currency

### 3. Install Frontend Dependencies

```bash
cd frontend

# Install TailwindCSS
npm install -D tailwindcss postcss autoprefixer
npx tailwindcss init -p

# Install UI libraries
npm install lucide-react
npm install embla-carousel-react
npm install clsx tailwind-merge
```

### 4. Start Development Server

```bash
npm start
```

Visit `http://localhost:3000` to see your homepage.

## 🎨 Design Colors & Fonts

### Color Palette (from Figma)
```css
--espresso-black: #1A1A1A
--espresso-cream: #E8E3D8
--espresso-beige: #D4CFC4
--espresso-orange: #E85D2A
--espresso-brown: #4A3428
```

### Typography
- **Font Family**: Inter (sans-serif)
- **Letter Spacing**: 0.15em for uppercase headings
- **Font Weights**: Light (300), Regular (400), Medium (500)

## 📁 Project Structure

```
frontend/src/
├── components/
│   ├── Header.tsx                 ✅ Sticky header with scroll behavior
│   ├── HeroSection.tsx            ✅ Full-screen hero
│   ├── ProductCarousel.tsx        ✅ Carousel with navigation
│   ├── CollectionSection.tsx      ✅ Curated collections display
│   ├── StorySection.tsx           ✅ Brand story section
│   ├── FarmSection.tsx            ✅ Farm to cup narrative
│   ├── InstantCoffeeSection.tsx   ✅ Product spotlight
│   ├── OriginSection.tsx          ✅ Coffee origins grid
│   ├── AchievementsSection.tsx    ✅ Awards & achievements
│   ├── LabSection.tsx             ✅ News & blog preview
│   ├── LocationsSection.tsx       ✅ Physical locations
│   └── Footer.tsx                 ✅ Site footer
├── pages/
│   └── HomePage.tsx               ✅ Complete homepage layout
├── App.tsx                        ✅ Updated routing
└── index.css                      ✅ TailwindCSS configuration
```

## 🖼️ Image Assets Required

Place these images in `public/images/`:

### Homepage Images
- `hero-coffee-cup.jpg` - Hero section background
- `logo.png` - Main logo
- `logo-light.png` - Light version for dark backgrounds

### Product Images
- `product-panama.jpg`
- `product-signature.jpg`
- `product-ethiopia.jpg`
- `bestseller-1.jpg`
- `bestseller-2.jpg`
- `bestseller-3.jpg`

### Collection Images
- `collection-1.jpg`
- `collection-2.jpg`
- `signature-collection.jpg`

### Story Section
- `latte-art.jpg`
- `coffee-beans.jpg`

### Other Sections
- `farm-landscape.jpg`
- `instant-coffee-box.jpg`
- `origin-panama.jpg`
- `origin-ethiopia.jpg`
- `origin-yemen.jpg`
- `origin-columbia.jpg`
- `champions.jpg`
- `news-1.jpg` through `news-4.jpg`
- `location-d3.jpg`
- `location-alquoz.jpg`
- `location-abudhabi.jpg`
- `location-nadal.jpg`

### Payment Icons
- `payment-amex.svg`
- `payment-applepay.svg`
- `payment-mastercard.svg`
- `payment-visa.svg`

## 🔌 Connect to Supabase & Sanity

Ensure `.env.local` is configured:

```env
# Supabase
REACT_APP_SUPABASE_URL=your_supabase_url
REACT_APP_SUPABASE_ANON_KEY=your_anon_key

# Sanity
REACT_APP_SANITY_PROJECT_ID=your_project_id
REACT_APP_SANITY_DATASET=production

# Stripe (optional for now)
REACT_APP_STRIPE_PUBLIC_KEY=your_stripe_key
```

## 📱 Features Implemented

### Header Component
- ✅ Top banner with promotional message
- ✅ Social media links (Facebook, Instagram, YouTube)
- ✅ Currency selector
- ✅ Search bar
- ✅ User account, wishlist, cart icons with badges
- ✅ Main navigation menu
- ✅ Sticky behavior on scroll
- ✅ Mobile responsive with hamburger menu

### Product Carousel
- ✅ Horizontal scrolling with navigation arrows
- ✅ Product cards with image, name, price
- ✅ Wishlist heart icon
- ✅ "Buy Now" button
- ✅ Responsive grid (1/2/3 columns)

### Content Sections
- ✅ Hero section with overlay text
- ✅ Category tabs for product filtering
- ✅ Collections showcase
- ✅ Story section with grid layout
- ✅ Full-width farm section
- ✅ Instant coffee spotlight
- ✅ Origin countries grid
- ✅ Achievements with statistics
- ✅ News/blog preview cards
- ✅ Location cards with addresses

### Footer
- ✅ Company links
- ✅ Product links
- ✅ Contact information
- ✅ Physical address
- ✅ Payment method icons
- ✅ Copyright notice

## 🚀 Next Steps

1. **Upload images** to the appropriate locations
2. **Configure Sanity** with actual content
3. **Connect products** from Supabase to the carousel components
4. **Add internationalization** (i18n) for Arabic support
5. **Implement cart functionality**
6. **Add authentication flows**
7. **Create product detail pages**
8. **Build checkout process**

## 📝 Notes

- All components are TypeScript with full type safety
- Responsive design using TailwindCSS breakpoints
- Icons from lucide-react library
- Smooth scroll behavior enabled
- Hover effects on interactive elements
- Accessibility considerations (alt text, semantic HTML)

## 🐛 Current Lint Warnings

The following warnings will resolve after running `npm install`:
- `Cannot find module 'lucide-react'` - Install with npm
- `Unknown at rule @tailwind` - Normal before TailwindCSS is installed

## 📞 Support

For issues or questions:
- Check Supabase dashboard for database status
- Verify Sanity Studio is running on port 3333
- Check browser console for runtime errors
- Ensure all environment variables are set correctly
