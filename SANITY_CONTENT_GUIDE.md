# Sanity Studio Content Management Guide

## ✅ Setup Status

**Sanity Studio**: Running at http://localhost:3333
**Frontend**: Running at http://localhost:3000
**Supabase Storage**: All 5 buckets created with RLS policies ✓

## 📋 Available Schemas

### 1. Site Settings (siteSettings)
**Purpose**: Global site configuration
**Fields**:
- Site title
- Logo (main & light version)
- Favicon
- Top banner (English & Arabic)
- Social media links (Facebook, Instagram, YouTube, Twitter, TikTok)
- Contact information (email, phone, address, TRN)
- Default currency

**Usage**: Singleton document (only one instance)

### 2. Product (product)
**Fields**:
- SKU, Name (EN/AR), Description (EN/AR)
- Price, Sale Price, Stock
- Category reference
- Collections reference (many-to-many)
- Taste profiles reference (many-to-many)
- Roast profiles reference (many-to-many)
- Images array
- Variants (size, grind type, price)
- 3 Graph objects (Excel import data)
- Flags: is_active, is_featured, is_wholesale_only

### 3. Category (category)
**Fields**:
- Name (EN/AR)
- Description (EN/AR)
- Slug
- Icon
- Order

### 4. Collection (collection)
**Fields**:
- Title (EN/AR)
- Description (EN/AR)
- Slug
- Image
- Order

### 5. Taste Profile (tasteProfile)
**Fields**:
- Title (EN/AR)
- Icon

### 6. Roast Profile (roastProfile)
**Fields**:
- Title (EN/AR)
- Icon

### 7. Discount (discount)
**Fields**:
- Code, Title (EN/AR), Description (EN/AR)
- Discount type & value
- Minimum purchase, usage limits
- Validity period
- Wholesale-only flag
- Applicable products

### 8. Course (course)
**Fields**:
- Title (EN/AR), Description (EN/AR)
- Duration, price, max participants
- Prerequisites, what to bring
- Images, syllabus
- Active status

### 9. QC Question (qcQuestion)
**Fields**:
- Question (EN/AR)
- Category, type
- Required status

### 10. Team Member (teamMember)
**Fields**:
- Name, role, bio (EN/AR)
- Photo
- Social links

## 🔌 Frontend Integration

### Fetching Content

```typescript
import { getSiteSettings, getProducts, getFeaturedProducts, getCollections } from './lib/sanityHelpers';

// In your component
const [settings, setSettings] = useState(null);

useEffect(() => {
  getSiteSettings().then(setSettings);
}, []);

// Get image URL
import { getImageUrl } from './lib/sanityHelpers';
const logoUrl = getImageUrl(settings?.logo, 200, 100);
```

### Available Helper Functions
- `getSiteSettings()` - Fetch site configuration
- `getProducts()` - Fetch all active products
- `getFeaturedProducts()` - Fetch featured products
- `getCollections()` - Fetch all collections
- `getCategories()` - Fetch all categories
- `getImageUrl(image, width?, height?)` - Get optimized image URL
- `formatPrice(price, currency?)` - Format price with currency

## 🧪 Testing Sanity Content

### Step 1: Create Site Settings
1. Open http://localhost:3333
2. Click "Site Settings" in the left sidebar
3. Fill in:
   - Site Title: "The Espresso Lab"
   - Upload logo and favicon
   - Add social media URLs
   - Add contact information

### Step 2: Create Categories
Create these categories in order:
1. Specialty Coffee
2. Instant Coffee
3. Specialty Gadgets
4. Jasmine Cups

### Step 3: Create Collections
Create collections:
1. Signature Collection
2. Auction Lots
3. Rare Lots
4. Reserve Lots

### Step 4: Create Products
For each product:
1. Add SKU and bilingual names
2. Set price and stock quantity
3. Assign category and collections
4. Upload product images
5. Toggle "is_active" and "is_featured" flags
6. Add variants if needed

### Step 5: Verify Frontend Integration
1. Check homepage displays products
2. Verify images load from Sanity
3. Test carousel navigation
4. Confirm bilingual content switches

## 📦 Supabase Storage Buckets

Successfully created:
1. **product-images** - Product photos (public)
2. **site-assets** - Logo, favicon, icons (public)
3. **blog-images** - Blog/news photos (public)
4. **location-images** - Store location photos (public)
5. **user-uploads** - User-specific files (private)

### RLS Policies
- ✅ Public read access for public buckets
- ✅ Admin-only write access
- ✅ User-specific folder access for private uploads

## 🎨 Image Management

### Sanity Images
- Automatically optimized
- CDN delivery
- On-the-fly resizing
- WebP conversion

### Supabase Images
- Direct file uploads
- Manual optimization recommended
- Use for user-generated content

## 🌍 Multi-language Support

All content fields support:
- English (en)
- Arabic (ar)

Frontend should detect language preference and display accordingly.

## 🔄 Content Workflow

1. **Create** content in Sanity Studio
2. **Publish** to make it live
3. **Frontend** automatically fetches via API
4. **Cache** enabled for performance (CDN)

## 📝 Next Steps

1. ✅ Sanity Studio running
2. ✅ All schemas created
3. ✅ Storage buckets configured
4. ✅ Frontend helpers ready
5. ⏳ Add sample content in Sanity
6. ⏳ Test frontend integration
7. ⏳ Add i18n language switcher
8. ⏳ Connect cart to Supabase
