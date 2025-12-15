# Updated Database Structure - The Espresso Lab

## 🎯 Changes Made

### 1. **Collections Table** (NEW - Separate from Products)
- Collections are now a **separate table** like categories
- **Many-to-many** relationship with products via `product_collections` junction table
- Supports Arabic (title_en, title_ar, description_en, description_ar)

### 2. **Taste Profiles** (UPDATED)
- **Removed**: description fields
- **Kept**: title_en, title_ar only
- Many-to-many with products

### 3. **Roast Profiles** (UPDATED)
- **Removed**: description fields
- **Kept**: title_en, title_ar only
- Many-to-many with products

### 4. **Product Graphs** (RESTRUCTURED)
- **Removed**: Single `product_graphs` table
- **Created**: 3 separate tables for Excel import:
  - `product_graph_1` (Acidity vs Body)
  - `product_graph_2` (Sweetness vs Bitterness)
  - `product_graph_3` (Aroma vs Aftertaste)
- Each table has: product_id, value_x, value_y, labels (EN/AR)
- **1-to-1** relationship with products (UNIQUE constraint on product_id)

### 5. **Arabic Support**
All content tables have bilingual fields:
- Products, Categories, Collections, Courses
- Taste Profiles, Roast Profiles
- Graph labels

---

## 📊 Complete Table List (26 Tables)

**Core Content (with Arabic):**
1. profiles
2. categories (title_en/ar, description_en/ar)
3. collections (NEW - title_en/ar, description_en/ar)
4. taste_profiles (title_en/ar only)
5. roast_profiles (title_en/ar only)
6. products (title_en/ar, description_en/ar, short_description_en/ar)
7. product_variants (title_en/ar)

**Product Relations (Many-to-Many):**
8. product_collections (NEW - junction table)
9. product_taste_profiles (junction table)
10. product_roast_profiles (junction table)

**Product Graphs (Separate Tables for Excel Import):**
11. product_graph_1 (Acidity vs Body)
12. product_graph_2 (Sweetness vs Bitterness)
13. product_graph_3 (Aroma vs Aftertaste)

**Inventory:**
14. inventory_transactions

**Courses:**
15. courses (title_en/ar, description_en/ar)
16. course_schedules
17. course_bookings

**Orders:**
18. orders
19. order_items

**QC System:**
20. qc_appointments
21. qc_reports
22. qc_answers
23. qc_feedback

**Other:**
24. wishlist_items
25. notifications

---

## 🔗 Relationships

```
Products (1) ←→ (Many) product_collections ←→ (Many) collections
Products (1) ←→ (Many) product_taste_profiles ←→ (Many) taste_profiles
Products (1) ←→ (Many) product_roast_profiles ←→ (Many) roast_profiles
Products (1) ←→ (1) product_graph_1
Products (1) ←→ (1) product_graph_2
Products (1) ←→ (1) product_graph_3
```

---

## 📥 Excel Import Structure for Graphs

Each graph table has a simple structure perfect for Excel import:

**CSV Format Example:**
```csv
product_id,value_x,value_y
uuid-1,7.5,8.2
uuid-2,6.0,7.5
uuid-3,8.5,9.0
```

**Import Command:**
```sql
COPY product_graph_1 (product_id, value_x, value_y)
FROM '/path/to/graph1_data.csv'
DELIMITER ','
CSV HEADER;
```

---

## 🚀 Deployment

**File**: `@c:\Users\user\Desktop\WS\espressolab\supabase\RUN_THIS_COMPLETE_DB.sql`

1. Open Supabase Dashboard
2. Go to SQL Editor
3. Copy entire file contents
4. Paste and Run

---

## 📝 Sanity CMS Updates

**New Content Type:**
- ✅ Collection (like Category, with EN/AR support)

**Updated Content Types:**
- ✅ Product - Collections now references, graphs as inline objects
- ✅ Taste Profile - Description removed
- ✅ Roast Profile - Description removed
- ✅ Category - Arabic fields added
- ✅ Course - Arabic fields added

**Removed:**
- ❌ productGraph.ts (replaced with inline objects in product)

---

## 🌍 Query Examples

**Get product with all relations:**
```sql
SELECT 
    p.*,
    json_agg(DISTINCT c.*) as collections,
    json_agg(DISTINCT tp.*) as taste_profiles,
    json_agg(DISTINCT rp.*) as roast_profiles,
    g1.* as graph_1,
    g2.* as graph_2,
    g3.* as graph_3
FROM products p
LEFT JOIN product_collections pc ON p.id = pc.product_id
LEFT JOIN collections c ON pc.collection_id = c.id
LEFT JOIN product_taste_profiles ptp ON p.id = ptp.product_id
LEFT JOIN taste_profiles tp ON ptp.taste_profile_id = tp.id
LEFT JOIN product_roast_profiles prp ON p.id = prp.product_id
LEFT JOIN roast_profiles rp ON prp.roast_profile_id = rp.id
LEFT JOIN product_graph_1 g1 ON p.id = g1.product_id
LEFT JOIN product_graph_2 g2 ON p.id = g2.product_id
LEFT JOIN product_graph_3 g3 ON p.id = g3.product_id
WHERE p.id = 'product-uuid'
GROUP BY p.id, g1.id, g2.id, g3.id;
```

---

**All updates complete!** 🎉
