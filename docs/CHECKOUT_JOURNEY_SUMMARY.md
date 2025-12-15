# Checkout Journey - Complete Database Structure

## ✅ All Features Implemented

### **1. Cart System**
- `carts` - User shopping carts (1 per user)
- `cart_items` - Items in cart with quantity and price snapshot

### **2. Orders System**
- `orders` - Order records with discount support
- `order_items` - Line items for each order

### **3. Favourites**
- `favourites` - Renamed from wishlist_items

### **4. Discounts & Coupons**
- `discounts` - Coupon codes with usage limits
- `discount_products` - Product-specific discounts (many-to-many)
- Types: percentage, fixed_amount, free_shipping

### **5. Companies (Wholesale)**
- `companies` - Wholesale business entities
- Linked to profiles via `company_id`
- Approval workflow for wholesale access

### **6. Sample Requests (Wholesale)**
- `sample_requests` - Wholesale users request product samples
- Auto-generated request numbers (SMP-YYYYMMDD-0001)
- Approval workflow with tracking

### **7. Collections**
- `collections` - Separate table (not column in products)
- `product_collections` - Many-to-many with products

### **8. Graphs (3 Separate Tables)**
- `product_graph_1` - Acidity vs Body
- `product_graph_2` - Sweetness vs Bitterness
- `product_graph_3` - Aroma vs Aftertaste
- Ready for Excel import

### **9. Arabic Support**
- All content tables have _en and _ar fields

---

## 📊 Total Database: 30 Tables

**Checkout Journey (NEW):**
1. carts
2. cart_items
3. discounts
4. discount_products
5. favourites
6. companies
7. sample_requests

**Products & Content:**
8. categories
9. collections
10. taste_profiles
11. roast_profiles
12. products
13. product_collections
14. product_taste_profiles
15. product_roast_profiles
16. product_graph_1
17. product_graph_2
18. product_graph_3
19. product_variants
20. inventory_transactions

**Orders:**
21. orders (updated with discount_id, company_id)
22. order_items

**Courses:**
23. courses
24. course_schedules
25. course_bookings

**QC:**
26. qc_appointments
27. qc_reports
28. qc_answers
29. qc_feedback

**Other:**
30. notifications

---

## 🛒 Checkout Flow

```
1. Add to Cart → cart_items
2. Apply Coupon → discounts (validate)
3. Checkout → Create order
4. Payment → Update order status
5. Inventory Decrement → Automatic trigger
6. Discount Usage → Auto-increment usage_count
```

---

## 🏢 Wholesale Flow

```
1. Register → Create profile
2. Submit Company Info → Create company
3. Admin Approval → Update company.approval_status
4. Request Sample → Create sample_request
5. Admin Approves Sample → Update status, ship
6. Place Order → Requires approval_status = 'approved'
```

---

## 📥 Excel Import for Graphs

**product_graph_1.csv:**
```csv
product_id,value_x,value_y
uuid-here,7.5,8.2
```

**SQL:**
```sql
COPY product_graph_1 (product_id, value_x, value_y)
FROM '/path/to/file.csv' DELIMITER ',' CSV HEADER;
```

---

## 🚀 Deploy

**File**: `@c:\Users\user\Desktop\WS\espressolab\supabase\DEPLOY_DATABASE.sql`

Copy entire file → Supabase SQL Editor → Run

---

## 📝 Sanity CMS Updated

**New Schemas:**
- Collection
- Discount

**Updated:**
- Product (collections as references, graphs as objects)
- Taste Profile (title only)
- Roast Profile (title only)

**All schemas loaded in Sanity Studio at http://localhost:3333**
