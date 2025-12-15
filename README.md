# The Espresso Lab - E-Commerce Platform

A modern, full-stack e-commerce platform for specialty coffee with integrated Quality Control (QC) system, wholesale portal, and course booking functionality.

## 🏗️ Architecture

### Tech Stack
- **Frontend**: React (with TypeScript)
- **Backend**: Supabase (PostgreSQL + Edge Functions)
- **CMS**: Sanity.io
- **Payment**: Stripe
- **Email**: Resend
- **Languages**: English/Arabic (i18n)

### Architecture Philosophy

This project uses a **hybrid data architecture** that separates concerns:

1. **Sanity CMS** - Handles rich, static content:
   - Product descriptions, stories, tasting notes
   - Blog posts and marketing pages
   - QC question templates
   - Course content
   - Team member profiles

2. **Supabase** - Manages operational, real-time data:
   - Inventory (stock quantities, prices)
   - Orders and transactions
   - User profiles and authentication
   - QC reports and appointments
   - Course bookings and schedules

3. **React Frontend** - Orchestrates both:
   - Fetches content from Sanity for display
   - Queries Supabase for real-time operational data
   - Combines both for complete user experience

## 📁 Project Structure

```
espressolab/
├── docs/
│   └── database-schema-diagram.md    # Complete ERD and data flow diagrams
├── supabase/
│   ├── migrations/
│   │   ├── 001_initial_schema.sql    # Database tables and relationships
│   │   └── 002_row_level_security.sql # RLS policies for security
│   └── functions/
│       ├── send-order-notification/   # Email notifications for orders
│       ├── send-qc-notification/      # Email notifications for QC reports
│       └── README.md                  # Edge Functions documentation
├── sanity/
│   └── schemas/
│       ├── product.ts                 # Product content schema
│       ├── category.ts                # Category schema
│       ├── course.ts                  # Course content schema
│       ├── qcQuestion.ts              # QC question templates
│       ├── blockContent.ts            # Rich text editor config
│       └── index.ts                   # Schema exports
└── README.md                          # This file
```

## 🚀 Key Features

### 1. **E-Commerce Core**
- Product catalog with categories and collections
- Shopping cart and checkout
- Stripe payment integration
- Bank transfer with receipt upload
- Order tracking and management
- Multi-language support (EN/AR)

### 2. **Inventory Management**
- Real-time stock tracking
- Automatic inventory decrements on order
- Low stock alerts
- Inventory transaction audit trail
- Admin dashboard with stock insights

### 3. **Quality Control (QC) Module**
- **For Wholesale Customers**:
  - Request QC appointments for orders
  - View QC reports and history
  - Provide feedback on inspections
  
- **For Admins**:
  - Schedule QC appointments
  - Customizable inspection forms (managed in Sanity)
  - Upload inspection images
  - Generate and share QC reports
  - Email notifications to customers

### 4. **Wholesale Portal**
- Separate approval workflow for wholesale accounts
- Access to wholesale-only products
- QC request system
- Order history and tracking
- Wishlist functionality

### 5. **Course Booking**
- Browse available courses
- Book courses by date/time
- Manage participant count
- Admin approval and rescheduling
- Email confirmations

### 6. **Admin Portal**
- Dashboard with sales analytics
- Order management and approval
- Product and inventory management
- Category management
- Course booking management
- QC appointment scheduling
- Sales reports export (date-to-date, user filtration)
- Wholesale account approval

## 🗄️ Database Schema

### Core Tables

**User Management**
- `profiles` - User profiles (extends Supabase auth)

**Products & Inventory**
- `categories` - Product categories
- `products` - Product operational data (SKU, price, stock)
- `product_variants` - Product variations (size, grind, etc.)
- `inventory_transactions` - Audit trail for stock changes

**Orders**
- `orders` - Order records
- `order_items` - Line items for each order

**Quality Control**
- `qc_appointments` - Scheduled QC inspections
- `qc_reports` - Inspection results
- `qc_answers` - Individual question responses
- `qc_feedback` - Customer feedback on reports

**Courses**
- `courses` - Course definitions
- `course_schedules` - Available time slots
- `course_bookings` - Customer bookings

**Other**
- `wishlist_items` - Saved products
- `notifications` - System notifications

See `@c:\Users\user\Desktop\WS\espressolab\docs\database-schema-diagram.md` for complete ERD and relationships.

## 🔒 Security

### Row Level Security (RLS)
All tables have RLS policies enforcing:
- **Customers**: Can only view/edit their own data
- **Wholesale**: Additional access to wholesale products and QC features (after approval)
- **Admins**: Full access to all data

### Authentication
- Supabase Auth handles user authentication
- Role-based access control (customer, wholesale, admin)
- Approval workflow for wholesale accounts

### Data Validation
- Database constraints ensure data integrity
- Triggers prevent negative inventory
- Audit trails for critical operations

## 📊 Data Flow Examples

### Order Processing Flow
1. Customer adds products to cart
2. Checkout → Payment (Stripe or Bank Transfer)
3. **Trigger**: Inventory automatically decremented
4. **Edge Function**: Email sent to admin and customer with invoice PDF
5. If wholesale order → QC appointment can be requested
6. Admin processes order → Ships → Updates tracking
7. Customer receives delivery confirmation

### QC Inspection Flow
1. Wholesale customer places order
2. Customer requests QC appointment
3. Admin schedules date/time
4. Admin conducts inspection using form (questions from Sanity)
5. Admin uploads photos and submits report
6. **Edge Function**: Email sent to customer with results
7. Customer views report and provides feedback
8. If passed → Order ships

### Real-Time Inventory Updates
1. Product page queries Supabase for current stock
2. Customer adds to cart (stock check)
3. Order placed → Payment confirmed
4. **Database Trigger**: Stock decremented
5. **Realtime Broadcast**: All connected clients receive update
6. Admin dashboard shows updated stock instantly
7. Product page disables "Add to Cart" if out of stock

## 🛠️ Setup Instructions

### Prerequisites
- Node.js 18+
- Supabase account
- Sanity account
- Stripe account
- Resend account (for emails)

### 1. Supabase Setup

```bash
# Install Supabase CLI
npm install -g supabase

# Login to Supabase
supabase login

# Link to your project
supabase link --project-ref your-project-ref

# Run migrations
supabase db push

# Deploy Edge Functions
supabase functions deploy

# Set environment secrets
supabase secrets set RESEND_API_KEY=your_key
supabase secrets set ADMIN_EMAIL=admin@espressolab.com
```

### 2. Sanity Setup

```bash
# Navigate to sanity directory
cd sanity

# Install dependencies
npm install

# Initialize Sanity project
npx sanity init

# Import schemas (already created in schemas/)
# Start Sanity Studio
npm run dev
```

### 3. Frontend Setup (React)

```bash
# Create React app with TypeScript
npx create-react-app frontend --template typescript

# Install dependencies
npm install @supabase/supabase-js
npm install @sanity/client
npm install @stripe/stripe-js @stripe/react-stripe-js
npm install react-router-dom
npm install i18next react-i18next

# Set environment variables
# Create .env file with:
REACT_APP_SUPABASE_URL=your_supabase_url
REACT_APP_SUPABASE_ANON_KEY=your_anon_key
REACT_APP_SANITY_PROJECT_ID=your_project_id
REACT_APP_SANITY_DATASET=production
REACT_APP_STRIPE_PUBLIC_KEY=your_stripe_key
```

### 4. Configure Storage Buckets

In Supabase Dashboard → Storage, create buckets:
- `qc-images` (for QC inspection photos)
- `bank-receipts` (for bank transfer receipts)
- `product-images` (optional, if not using Sanity)
- `documents` (for roasting PDFs, certificates)

Set appropriate RLS policies for each bucket.

## 🔄 Syncing Sanity ↔ Supabase

Products exist in both systems:
- **Sanity**: Content (descriptions, images, stories)
- **Supabase**: Operations (SKU, price, stock)

**Sync Point**: The `sanity_id` field in Supabase links to Sanity documents.

**Workflow**:
1. Create product in Sanity with all content
2. Note the Sanity document ID
3. Create corresponding record in Supabase `products` table with:
   - `sanity_id` = Sanity document ID
   - `sku`, `price`, `stock_quantity`, etc.

**Frontend Query**:
```typescript
// Fetch from both sources
const sanityContent = await sanityClient.fetch(productQuery)
const { data: supabaseData } = await supabase
  .from('products')
  .select('*')
  .eq('sanity_id', sanityContent._id)
  .single()

// Combine for display
const product = { ...sanityContent, ...supabaseData }
```

## 📧 Email Notifications

Automated emails are sent for:
- ✅ Order placed (customer + admin)
- ✅ Payment confirmed (customer)
- ✅ Order shipped with tracking (customer)
- ✅ QC report completed (customer)
- ✅ Course booking confirmed (customer)
- ✅ Wholesale account approved/rejected (customer)

All emails include:
- Professional HTML templates
- Invoice PDFs (for orders)
- Direct links to relevant pages
- Bilingual support (EN/AR)

## 📱 Pages & Routes

### Public Pages
- `/` - Home
- `/about` - About Us
- `/contact` - Contact
- `/team` - Meet the Team
- `/products` - Product catalog
- `/products/:slug` - Product details
- `/courses` - Course listings
- `/courses/:slug` - Course details
- `/blog` - News & Blogs
- `/wholesale` - Wholesale home

### Customer Portal (Auth Required)
- `/dashboard` - Customer dashboard
- `/orders` - Order history
- `/orders/:id` - Order details
- `/wishlist` - Saved products

### Wholesale Portal (Wholesale Role + Approved)
- `/wholesale/dashboard` - Wholesale dashboard
- `/wholesale/products` - Wholesale products
- `/wholesale/orders` - Order management
- `/wholesale/qc-reports` - QC history
- `/wholesale/qc-request` - Request new QC

### Admin Portal (Admin Role)
- `/admin/dashboard` - Analytics dashboard
- `/admin/orders` - Order management
- `/admin/products` - Product management
- `/admin/inventory` - Inventory management
- `/admin/categories` - Category management
- `/admin/courses` - Course management
- `/admin/qc` - QC appointments
- `/admin/wholesale` - Wholesale approvals
- `/admin/reports` - Sales reports

## 🌍 Internationalization (i18n)

Support for English and Arabic:
- Use `react-i18next` for translations
- RTL support for Arabic
- Date/number formatting per locale
- Separate translation files per language

## 🧪 Testing

```bash
# Run tests
npm test

# E2E tests (recommended: Playwright or Cypress)
npm run test:e2e
```

## 📈 Performance Optimization

- **Supabase Realtime**: Instant updates for inventory
- **Image Optimization**: Use Sanity's image CDN
- **Caching**: Cache Sanity content, query Supabase for fresh data
- **Indexes**: All foreign keys and frequently queried fields indexed
- **Edge Functions**: Run close to users for low latency

## 🚢 Deployment

### Supabase
- Already hosted (managed service)
- Deploy Edge Functions via CLI

### Sanity Studio
```bash
npm run build
npx sanity deploy
```

### React Frontend
Deploy to Vercel, Netlify, or similar:
```bash
npm run build
# Deploy build/ directory
```

## 📝 Environment Variables

### Frontend (.env)
```
REACT_APP_SUPABASE_URL=
REACT_APP_SUPABASE_ANON_KEY=
REACT_APP_SANITY_PROJECT_ID=
REACT_APP_SANITY_DATASET=
REACT_APP_STRIPE_PUBLIC_KEY=
```

### Supabase Secrets
```
RESEND_API_KEY=
ADMIN_EMAIL=
```

## 🤝 Contributing

1. Follow the established architecture patterns
2. Maintain separation between Sanity (content) and Supabase (operations)
3. Add RLS policies for any new tables
4. Document any new Edge Functions
5. Update this README for significant changes

## 📄 License

Proprietary - The Espresso Lab

## 🆘 Support

For questions or issues:
- Technical: dev@espressolab.com
- Business: info@espressolab.com

---

**Built with ☕ by The Espresso Lab Team**
