# The Espresso Lab - Final Database Summary

## ✅ Complete Database with All New Features

### 🆕 New Features Added

1. **Taste Profiles** (Many-to-Many with Products)
2. **Roast Profiles** (Many-to-Many with Products)
3. **Product Graphs** (3 graphs per product, each with 2 values)
4. **Arabic Language Support** (All content tables have EN/AR fields)

---

## 📊 Database Structure

### **New Tables**

#### 1. `taste_profiles`
```sql
- id (UUID, PK)
- sanity_id (TEXT, unique)
- title_en (TEXT) - English title
- title_ar (TEXT) - Arabic title
- description_en (TEXT)
- description_ar (TEXT)
- is_active (BOOLEAN)
- sort_order (INTEGER)
```

#### 2. `roast_profiles`
```sql
- id (UUID, PK)
- sanity_id (TEXT, unique)
- title_en (TEXT) - English title
- title_ar (TEXT) - Arabic title
- description_en (TEXT)
- description_ar (TEXT)
- is_active (BOOLEAN)
- sort_order (INTEGER)
```

#### 3. `product_taste_profiles` (Many-to-Many Junction)
```sql
- id (UUID, PK)
- product_id (UUID, FK → products)
- taste_profile_id (UUID, FK → taste_profiles)
- UNIQUE(product_id, taste_profile_id)
```

#### 4. `product_roast_profiles` (Many-to-Many Junction)
```sql
- id (UUID, PK)
- product_id (UUID, FK → products)
- roast_profile_id (UUID, FK → roast_profiles)
- UNIQUE(product_id, roast_profile_id)
```

#### 5. `product_graphs` (3 Graphs with 2 Values Each)
```sql
- id (UUID, PK)
- product_id (UUID, FK → products, UNIQUE)

-- Graph 1: Acidity vs Body
- graph_1_name_en, graph_1_name_ar
- graph_1_value_x (0-10)
- graph_1_value_y (0-10)
- graph_1_label_x_en, graph_1_label_x_ar
- graph_1_label_y_en, graph_1_label_y_ar

-- Graph 2: Sweetness vs Bitterness
- graph_2_name_en, graph_2_name_ar
- graph_2_value_x (0-10)
- graph_2_value_y (0-10)
- graph_2_label_x_en, graph_2_label_x_ar
- graph_2_label_y_en, graph_2_label_y_ar

-- Graph 3: Aroma vs Aftertaste
- graph_3_name_en, graph_3_name_ar
- graph_3_value_x (0-10)
- graph_3_value_y (0-10)
- graph_3_label_x_en, graph_3_label_x_ar
- graph_3_label_y_en, graph_3_label_y_ar
```

### **Updated Tables (Arabic Support)**

#### `products`
```sql
- title_en, title_ar
- description_en, description_ar
- short_description_en, short_description_ar
```

#### `categories`
```sql
- title_en, title_ar
- description_en, description_ar
```

#### `courses`
```sql
- title_en, title_ar
- description_en, description_ar
- short_description_en, short_description_ar
```

#### `product_variants`
```sql
- title_en, title_ar
```

---

## 🔗 Relationships Diagram

```
Products (1) ←→ (Many) product_taste_profiles ←→ (Many) taste_profiles
Products (1) ←→ (Many) product_roast_profiles ←→ (Many) roast_profiles
Products (1) ←→ (1) product_graphs
```

### Example Queries

**Get product with all taste profiles:**
```sql
SELECT 
    p.*,
    json_agg(DISTINCT tp.*) as taste_profiles
FROM products p
LEFT JOIN product_taste_profiles ptp ON p.id = ptp.product_id
LEFT JOIN taste_profiles tp ON ptp.taste_profile_id = tp.id
WHERE p.id = 'product-uuid'
GROUP BY p.id;
```

**Get product with graphs:**
```sql
SELECT 
    p.title_en,
    p.title_ar,
    pg.graph_1_value_x,
    pg.graph_1_value_y,
    pg.graph_2_value_x,
    pg.graph_2_value_y,
    pg.graph_3_value_x,
    pg.graph_3_value_y
FROM products p
LEFT JOIN product_graphs pg ON p.id = pg.product_id
WHERE p.id = 'product-uuid';
```

---

## 📝 Sanity CMS Updates

### New Content Types

1. **Taste Profile** (`tasteProfile.ts`)
   - Title (EN/AR)
   - Description (EN/AR)
   - Active status
   - Sort order

2. **Roast Profile** (`roastProfile.ts`)
   - Title (EN/AR)
   - Description (EN/AR)
   - Active status
   - Sort order

3. **Product Graph** (`productGraph.ts`)
   - Graph name (EN/AR)
   - X/Y values (0-10 scale)
   - Axis labels (EN/AR)

### Updated Content Types

**Product** - Now includes:
- ✅ Arabic fields (title, description, story)
- ✅ Taste Profiles (multi-select references)
- ✅ Roast Profiles (multi-select references)
- ✅ Graphs array (up to 3 graphs)

**Category** - Now includes:
- ✅ Arabic fields (title, description)

**Course** - Now includes:
- ✅ Arabic fields (title, descriptions)

---

## 🚀 How to Deploy

### Step 1: Run SQL in Supabase

**File**: `@c:\Users\user\Desktop\WS\espressolab\supabase\COMPLETE_FINAL_DATABASE.sql`

1. Open Supabase Dashboard
2. Go to **SQL Editor**
3. Create **New Query**
4. Copy entire contents of `COMPLETE_FINAL_DATABASE.sql`
5. Click **Run**

This creates:
- ✅ 21 tables (including new taste/roast profiles and graphs)
- ✅ All indexes
- ✅ All triggers
- ✅ All RLS policies
- ✅ All functions

### Step 2: Verify Sanity Studio

Sanity Studio at `http://localhost:3333` now has:
- ✅ Taste Profiles management
- ✅ Roast Profiles management
- ✅ Product graphs editor
- ✅ Arabic language fields for all content

---

## 🌍 Bilingual Support (EN/AR)

### Frontend Implementation

```typescript
// Get current language from i18n
const { i18n } = useTranslation()
const lang = i18n.language // 'en' or 'ar'

// Display bilingual content
const productTitle = lang === 'ar' ? product.title_ar : product.title_en
const productDesc = lang === 'ar' ? product.description_ar : product.description_en
```

### Database Query Example

```typescript
// Fetch product with language preference
const { data } = await supabase
  .from('products')
  .select(`
    *,
    category:categories(title_en, title_ar),
    taste_profiles:product_taste_profiles(
      taste_profile:taste_profiles(title_en, title_ar)
    ),
    roast_profiles:product_roast_profiles(
      roast_profile:roast_profiles(title_en, title_ar)
    ),
    graphs:product_graphs(*)
  `)
  .eq('id', productId)
  .single()
```

---

## 📈 Product Graphs Visualization

Each product can have **3 graphs**, each with **2 values** (X and Y):

**Default Graphs:**
1. **Acidity vs Body** (الحموضة مقابل القوام)
2. **Sweetness vs Bitterness** (الحلاوة مقابل المرارة)
3. **Aroma vs Aftertaste** (الرائحة مقابل الطعم المتبقي)

**Values**: 0-10 scale for both X and Y axes

**Frontend Display Example:**
```typescript
// Render graph using Chart.js or similar
<ScatterChart
  data={[
    { x: product.graphs.graph_1_value_x, y: product.graphs.graph_1_value_y }
  ]}
  xLabel={lang === 'ar' ? graph.graph_1_label_x_ar : graph.graph_1_label_x_en}
  yLabel={lang === 'ar' ? graph.graph_1_label_y_ar : graph.graph_1_label_y_en}
/>
```

---

## 🔄 Data Flow with New Features

```
Sanity Studio (localhost:3333)
    ↓
1. Create Taste Profile (EN/AR)
2. Create Roast Profile (EN/AR)
3. Create Product with:
   - Basic info (EN/AR)
   - Select multiple taste profiles
   - Select multiple roast profiles
   - Add 3 graphs with values
    ↓
Sanity Cloud saves content
    ↓
Supabase stores operational data:
   - product_taste_profiles (links)
   - product_roast_profiles (links)
   - product_graphs (values)
    ↓
React Frontend fetches both
    ↓
Displays bilingual product page with graphs
```

---

## 📋 Complete Table List (21 Tables)

**Core:**
1. profiles
2. categories ✨ (with AR)
3. taste_profiles ✨ (NEW)
4. roast_profiles ✨ (NEW)
5. products ✨ (with AR)
6. product_variants ✨ (with AR)
7. product_taste_profiles ✨ (NEW - junction)
8. product_roast_profiles ✨ (NEW - junction)
9. product_graphs ✨ (NEW)
10. inventory_transactions

**Orders:**
11. orders
12. order_items

**QC:**
13. qc_appointments
14. qc_reports
15. qc_answers
16. qc_feedback

**Courses:**
17. courses ✨ (with AR)
18. course_schedules
19. course_bookings

**Other:**
20. wishlist_items
21. notifications

---

## ✅ What's Ready

**Supabase Database:**
- ✅ Complete SQL file ready to run
- ✅ 21 tables with all relationships
- ✅ Arabic support on all content
- ✅ Taste/Roast profiles with many-to-many
- ✅ Product graphs (3x2 values)

**Sanity CMS:**
- ✅ All schemas updated with Arabic fields
- ✅ Taste Profile content type
- ✅ Roast Profile content type
- ✅ Product Graph object type
- ✅ Running at http://localhost:3333

**React Frontend:**
- ✅ Running at http://localhost:3000
- ✅ Connected to Supabase
- ✅ Connected to Sanity
- ✅ Ready for bilingual implementation

---

## 🎯 Next Steps

1. **Run the SQL**: Execute `COMPLETE_FINAL_DATABASE.sql` in Supabase
2. **Create Content**: Add taste/roast profiles in Sanity Studio
3. **Add Products**: Create products with profiles and graphs
4. **Implement i18n**: Add language switcher in React app
5. **Display Graphs**: Use Chart.js or similar for visualization

---

**Your complete bilingual e-commerce platform with advanced product features is ready!** 🎉
