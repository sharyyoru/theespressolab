# Sanity Studio Setup - The Espresso Lab

## ✅ What's Been Configured

### 1. **Sanity Studio (Standalone)**
- **URL**: `http://localhost:3333` (runs separately from React app)
- **Status**: ✅ Fully configured and ready to install
- **Access**: Independent CMS interface

### 2. **CMS Schemas Created**
All content types are ready to manage:

- ✅ **Products** (`product.ts`)
  - Product name, SKU, descriptions
  - Images, galleries, videos
  - Tasting notes, process, producer info
  - Pricing, specifications, options
  - Collections, tags, SEO

- ✅ **Categories** (`category.ts`)
  - Category name, slug, description
  - Category images
  - Sort ordering

- ✅ **Courses** (`course.ts`)
  - Course title, descriptions
  - Duration, max participants, skill level
  - What you'll learn, requirements, includes
  - Instructor references
  - Images and galleries

- ✅ **QC Questions** (`qcQuestion.ts`)
  - Question templates for quality control
  - Answer types (rating, yes/no, text, multiple choice)
  - Categories (packaging, quality, labeling, etc.)
  - Help text for inspectors

- ✅ **Block Content** (`blockContent.ts`)
  - Rich text editor configuration
  - Headings, lists, links, images
  - Used across all content types

### 3. **Dependencies Installed**
```json
{
  "sanity": "^3.22.0",
  "@sanity/vision": "^3.x",
  "@sanity/client": "^6.10.0",
  "@sanity/image-url": "^2.0.2",
  "styled-components": "^6.1.0"
}
```

### 4. **Configuration Files**
- ✅ `frontend/src/sanity.config.ts` - Main Sanity Studio config
- ✅ `frontend/src/schemas/*` - All schema definitions
- ✅ `frontend/src/pages/Studio.tsx` - Studio page component
- ✅ `frontend/src/App.tsx` - Studio route configured

### 5. **Environment Variables**
Already configured in `.env.local`:
```
REACT_APP_SANITY_PROJECT_ID=gyft0w2o
REACT_APP_SANITY_DATASET=production
```

---

## 🚀 How to Access Sanity Studio

### Setup & Start Studio
```bash
cd c:\Users\user\Desktop\WS\espressolab\sanity
npm install
npm run dev
```

**Access at**: `http://localhost:3333`

Login with your Sanity account credentials when prompted.

---

## 📝 What You Can Do in the Studio

### Content Management
1. **Products**
   - Add new coffee products
   - Upload product images
   - Write rich descriptions and stories
   - Set tasting notes and origin info
   - Manage product collections

2. **Categories**
   - Create product categories
   - Organize products by type
   - Set category images and descriptions

3. **Courses**
   - Add training courses
   - Set schedules and pricing
   - Upload course materials
   - Assign instructors

4. **QC Questions**
   - Create quality control templates
   - Define inspection criteria
   - Set rating scales
   - Organize by category

---

## 🔄 How Data Flows

```
Sanity Studio (http://localhost:3000/studio)
    ↓
Content saved to Sanity Cloud
    ↓
React Frontend queries Sanity API
    ↓
Combines with Supabase operational data
    ↓
Displays on website
```

### Example: Product Display
1. **In Sanity**: Create product with description, images, tasting notes
2. **In Supabase**: Set SKU, price, stock quantity
3. **Frontend**: Fetches both and displays complete product

---

## 🔐 Authentication

### First Time Setup
1. Visit `http://localhost:3000/studio`
2. Click "Sign in"
3. Use your Sanity account (create one at sanity.io if needed)
4. Grant access to project `gyft0w2o`

### User Roles
- **Administrator**: Full access to all content
- **Editor**: Can edit content but not settings
- **Viewer**: Read-only access

---

## 📊 Available CMS Features

### Desk Tool
- Browse all content types
- Create, edit, delete documents
- Search and filter
- Bulk operations

### Vision Tool
- Test GROQ queries
- Debug data fetching
- Preview query results
- API playground

---

## 🛠️ Customization

### Adding New Content Types
1. Create schema file in `frontend/src/schemas/`
2. Import in `frontend/src/sanity.config.ts`
3. Add to schema types array
4. Studio auto-updates

### Modifying Existing Schemas
Edit the schema files in `frontend/src/schemas/`
- Changes appear immediately in Studio
- No rebuild required

---

## 🔗 Integration Points

### Frontend Integration
```typescript
// Query products from Sanity
import { sanityClient } from './lib/sanity'

const products = await sanityClient.fetch(`
  *[_type == "product" && is_active == true] {
    _id,
    title,
    slug,
    description,
    mainImage,
    price
  }
`)
```

### Supabase Sync
Products have a `sanity_id` field in Supabase that links to Sanity documents:
```sql
SELECT * FROM products WHERE sanity_id = 'sanity-document-id'
```

---

## ✅ Current Status

**All CMS pages are wired and ready to use!**

- ✅ Studio accessible at `/studio`
- ✅ All schemas configured
- ✅ Content types ready
- ✅ Authentication configured
- ✅ Integration with React app complete

---

## 📚 Next Steps

1. **Login to Studio**: Visit `http://localhost:3000/studio`
2. **Create Sample Content**: Add a test product or category
3. **Query from Frontend**: Fetch and display Sanity content
4. **Sync with Supabase**: Link Sanity products to Supabase inventory

---

## 🆘 Troubleshooting

### Studio Not Loading
- Check that Sanity packages are installed: `npm list sanity`
- Verify project ID in `.env.local`
- Clear browser cache and reload

### Authentication Issues
- Ensure you have a Sanity account
- Check project permissions at sanity.io/manage
- Verify project ID matches your Sanity project

### Schema Errors
- Check schema syntax in `frontend/src/schemas/`
