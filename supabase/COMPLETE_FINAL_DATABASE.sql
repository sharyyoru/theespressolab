-- =====================================================
-- THE ESPRESSO LAB - COMPLETE FINAL DATABASE
-- =====================================================
-- NEW: Taste Profiles, Roast Profiles, Product Graphs, Arabic Support
-- COPY AND PASTE THIS ENTIRE FILE INTO SUPABASE SQL EDITOR
-- =====================================================

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- ENUMS
DO $$ BEGIN
    CREATE TYPE user_role AS ENUM ('customer', 'wholesale', 'admin');
EXCEPTION WHEN duplicate_object THEN null; END $$;

DO $$ BEGIN
    CREATE TYPE approval_status AS ENUM ('pending', 'approved', 'rejected');
EXCEPTION WHEN duplicate_object THEN null; END $$;

DO $$ BEGIN
    CREATE TYPE collection_type AS ENUM ('new_arrivals', 'coffee', 'instant', 'drip', 'merch', 'wholesale_instant', 'rare_lots', 'reserve_lots', 'tel_signature', 's90', 'specialty_gadgets');
EXCEPTION WHEN duplicate_object THEN null; END $$;

DO $$ BEGIN
    CREATE TYPE order_status AS ENUM ('pending_payment', 'payment_received', 'processing', 'qc_scheduled', 'qc_completed', 'shipped', 'delivered', 'cancelled', 'refunded');
EXCEPTION WHEN duplicate_object THEN null; END $$;

DO $$ BEGIN
    CREATE TYPE payment_method AS ENUM ('stripe', 'bank_transfer');
EXCEPTION WHEN duplicate_object THEN null; END $$;

DO $$ BEGIN
    CREATE TYPE booking_status AS ENUM ('pending', 'confirmed', 'cancelled', 'completed', 'rescheduled');
EXCEPTION WHEN duplicate_object THEN null; END $$;

DO $$ BEGIN
    CREATE TYPE qc_appointment_status AS ENUM ('requested', 'scheduled', 'in_progress', 'completed', 'cancelled');
EXCEPTION WHEN duplicate_object THEN null; END $$;

DO $$ BEGIN
    CREATE TYPE notification_type AS ENUM ('order_placed', 'order_approved', 'order_shipped', 'qc_scheduled', 'qc_completed', 'course_booked', 'wholesale_approved', 'wholesale_rejected');
EXCEPTION WHEN duplicate_object THEN null; END $$;

-- TABLES
CREATE TABLE IF NOT EXISTS profiles (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    email TEXT UNIQUE NOT NULL,
    full_name TEXT,
    phone TEXT,
    role user_role DEFAULT 'customer' NOT NULL,
    approval_status approval_status DEFAULT 'pending',
    company_name TEXT,
    business_license TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS categories (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    sanity_id TEXT UNIQUE NOT NULL,
    slug TEXT UNIQUE NOT NULL,
    title_en TEXT NOT NULL,
    title_ar TEXT NOT NULL,
    description_en TEXT,
    description_ar TEXT,
    is_active BOOLEAN DEFAULT true,
    sort_order INTEGER DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS taste_profiles (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    sanity_id TEXT UNIQUE NOT NULL,
    title_en TEXT NOT NULL,
    title_ar TEXT NOT NULL,
    description_en TEXT,
    description_ar TEXT,
    is_active BOOLEAN DEFAULT true,
    sort_order INTEGER DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS roast_profiles (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    sanity_id TEXT UNIQUE NOT NULL,
    title_en TEXT NOT NULL,
    title_ar TEXT NOT NULL,
    description_en TEXT,
    description_ar TEXT,
    is_active BOOLEAN DEFAULT true,
    sort_order INTEGER DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS products (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    sanity_id TEXT UNIQUE NOT NULL,
    sku TEXT UNIQUE NOT NULL,
    category_id UUID REFERENCES categories(id) ON DELETE SET NULL,
    title_en TEXT NOT NULL,
    title_ar TEXT NOT NULL,
    description_en TEXT,
    description_ar TEXT,
    short_description_en TEXT,
    short_description_ar TEXT,
    price DECIMAL(10, 2) NOT NULL,
    stock_quantity INTEGER DEFAULT 0 NOT NULL,
    low_stock_threshold INTEGER DEFAULT 10,
    is_active BOOLEAN DEFAULT true,
    is_wholesale_only BOOLEAN DEFAULT false,
    collections collection_type[],
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    CONSTRAINT positive_stock CHECK (stock_quantity >= 0),
    CONSTRAINT positive_price CHECK (price >= 0)
);

CREATE TABLE IF NOT EXISTS product_taste_profiles (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    product_id UUID REFERENCES products(id) ON DELETE CASCADE,
    taste_profile_id UUID REFERENCES taste_profiles(id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(product_id, taste_profile_id)
);

CREATE TABLE IF NOT EXISTS product_roast_profiles (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    product_id UUID REFERENCES products(id) ON DELETE CASCADE,
    roast_profile_id UUID REFERENCES roast_profiles(id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(product_id, roast_profile_id)
);

CREATE TABLE IF NOT EXISTS product_graphs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    product_id UUID REFERENCES products(id) ON DELETE CASCADE,
    graph_1_name_en TEXT DEFAULT 'Acidity vs Body',
    graph_1_name_ar TEXT DEFAULT 'الحموضة مقابل القوام',
    graph_1_value_x DECIMAL(5, 2) NOT NULL,
    graph_1_value_y DECIMAL(5, 2) NOT NULL,
    graph_1_label_x_en TEXT DEFAULT 'Acidity',
    graph_1_label_x_ar TEXT DEFAULT 'الحموضة',
    graph_1_label_y_en TEXT DEFAULT 'Body',
    graph_1_label_y_ar TEXT DEFAULT 'القوام',
    graph_2_name_en TEXT DEFAULT 'Sweetness vs Bitterness',
    graph_2_name_ar TEXT DEFAULT 'الحلاوة مقابل المرارة',
    graph_2_value_x DECIMAL(5, 2) NOT NULL,
    graph_2_value_y DECIMAL(5, 2) NOT NULL,
    graph_2_label_x_en TEXT DEFAULT 'Sweetness',
    graph_2_label_x_ar TEXT DEFAULT 'الحلاوة',
    graph_2_label_y_en TEXT DEFAULT 'Bitterness',
    graph_2_label_y_ar TEXT DEFAULT 'المرارة',
    graph_3_name_en TEXT DEFAULT 'Aroma vs Aftertaste',
    graph_3_name_ar TEXT DEFAULT 'الرائحة مقابل الطعم المتبقي',
    graph_3_value_x DECIMAL(5, 2) NOT NULL,
    graph_3_value_y DECIMAL(5, 2) NOT NULL,
    graph_3_label_x_en TEXT DEFAULT 'Aroma',
    graph_3_label_x_ar TEXT DEFAULT 'الرائحة',
    graph_3_label_y_en TEXT DEFAULT 'Aftertaste',
    graph_3_label_y_ar TEXT DEFAULT 'الطعم المتبقي',
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(product_id)
);

CREATE TABLE IF NOT EXISTS product_variants (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    product_id UUID REFERENCES products(id) ON DELETE CASCADE,
    sanity_id TEXT,
    sku TEXT UNIQUE NOT NULL,
    title_en TEXT,
    title_ar TEXT,
    price_adjustment DECIMAL(10, 2) DEFAULT 0,
    stock_quantity INTEGER DEFAULT 0 NOT NULL,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    CONSTRAINT positive_variant_stock CHECK (stock_quantity >= 0)
);

CREATE TABLE IF NOT EXISTS inventory_transactions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    product_id UUID REFERENCES products(id) ON DELETE CASCADE,
    variant_id UUID REFERENCES product_variants(id) ON DELETE CASCADE,
    quantity_change INTEGER NOT NULL,
    transaction_type TEXT NOT NULL,
    reference_id UUID,
    notes TEXT,
    created_by UUID REFERENCES profiles(id),
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS courses (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    sanity_id TEXT UNIQUE NOT NULL,
    title_en TEXT NOT NULL,
    title_ar TEXT NOT NULL,
    description_en TEXT,
    description_ar TEXT,
    short_description_en TEXT,
    short_description_ar TEXT,
    price DECIMAL(10, 2) NOT NULL,
    duration_minutes INTEGER,
    max_participants INTEGER DEFAULT 10,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS course_schedules (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    course_id UUID REFERENCES courses(id) ON DELETE CASCADE,
    start_time TIMESTAMPTZ NOT NULL,
    end_time TIMESTAMPTZ NOT NULL,
    available_slots INTEGER NOT NULL,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    CONSTRAINT valid_time_range CHECK (end_time > start_time),
    CONSTRAINT positive_slots CHECK (available_slots >= 0)
);

CREATE TABLE IF NOT EXISTS course_bookings (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    course_id UUID REFERENCES courses(id) ON DELETE CASCADE,
    schedule_id UUID REFERENCES course_schedules(id) ON DELETE CASCADE,
    user_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
    participants_count INTEGER DEFAULT 1,
    status booking_status DEFAULT 'pending',
    payment_status TEXT DEFAULT 'pending',
    total_amount DECIMAL(10, 2) NOT NULL,
    notes TEXT,
    admin_notes TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    CONSTRAINT positive_participants CHECK (participants_count > 0)
);

CREATE TABLE IF NOT EXISTS orders (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    order_number TEXT UNIQUE NOT NULL,
    user_id UUID REFERENCES profiles(id) ON DELETE SET NULL,
    status order_status DEFAULT 'pending_payment',
    payment_method payment_method NOT NULL,
    payment_status TEXT DEFAULT 'pending',
    stripe_payment_intent_id TEXT,
    bank_transfer_receipt_url TEXT,
    subtotal DECIMAL(10, 2) NOT NULL,
    tax DECIMAL(10, 2) DEFAULT 0,
    shipping_fee DECIMAL(10, 2) DEFAULT 0,
    total_amount DECIMAL(10, 2) NOT NULL,
    shipping_full_name TEXT NOT NULL,
    shipping_phone TEXT NOT NULL,
    shipping_address_line1 TEXT NOT NULL,
    shipping_address_line2 TEXT,
    shipping_city TEXT NOT NULL,
    shipping_state TEXT,
    shipping_postal_code TEXT,
    shipping_country TEXT NOT NULL,
    tracking_number TEXT,
    shipped_at TIMESTAMPTZ,
    delivered_at TIMESTAMPTZ,
    notes TEXT,
    admin_notes TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    CONSTRAINT positive_amounts CHECK (subtotal >= 0 AND tax >= 0 AND shipping_fee >= 0 AND total_amount >= 0)
);

CREATE TABLE IF NOT EXISTS order_items (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    order_id UUID REFERENCES orders(id) ON DELETE CASCADE,
    product_id UUID REFERENCES products(id) ON DELETE SET NULL,
    variant_id UUID REFERENCES product_variants(id) ON DELETE SET NULL,
    product_name TEXT NOT NULL,
    product_sku TEXT NOT NULL,
    variant_details JSONB,
    quantity INTEGER NOT NULL,
    unit_price DECIMAL(10, 2) NOT NULL,
    total_price DECIMAL(10, 2) NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    CONSTRAINT positive_quantity CHECK (quantity > 0),
    CONSTRAINT positive_prices CHECK (unit_price >= 0 AND total_price >= 0)
);

CREATE TABLE IF NOT EXISTS qc_appointments (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    order_id UUID REFERENCES orders(id) ON DELETE CASCADE,
    user_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
    status qc_appointment_status DEFAULT 'requested',
    scheduled_date TIMESTAMPTZ,
    completed_date TIMESTAMPTZ,
    customer_notes TEXT,
    admin_notes TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS qc_reports (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    appointment_id UUID REFERENCES qc_appointments(id) ON DELETE CASCADE,
    order_id UUID REFERENCES orders(id) ON DELETE CASCADE,
    inspector_id UUID REFERENCES profiles(id) ON DELETE SET NULL,
    overall_rating INTEGER CHECK (overall_rating >= 1 AND overall_rating <= 5),
    overall_notes TEXT,
    images_urls TEXT[],
    passed BOOLEAN,
    completed_at TIMESTAMPTZ DEFAULT NOW(),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS qc_answers (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    report_id UUID REFERENCES qc_reports(id) ON DELETE CASCADE,
    question_sanity_id TEXT NOT NULL,
    question_text TEXT NOT NULL,
    answer_value TEXT,
    rating INTEGER CHECK (rating >= 1 AND rating <= 5),
    notes TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS qc_feedback (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    report_id UUID REFERENCES qc_reports(id) ON DELETE CASCADE,
    user_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
    rating INTEGER CHECK (rating >= 1 AND rating <= 5),
    comments TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS wishlist_items (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
    product_id UUID REFERENCES products(id) ON DELETE CASCADE,
    variant_id UUID REFERENCES product_variants(id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(user_id, product_id, variant_id)
);

CREATE TABLE IF NOT EXISTS notifications (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
    type notification_type NOT NULL,
    title TEXT NOT NULL,
    message TEXT NOT NULL,
    reference_id UUID,
    is_read BOOLEAN DEFAULT false,
    email_sent BOOLEAN DEFAULT false,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- INDEXES
CREATE INDEX IF NOT EXISTS idx_profiles_role ON profiles(role);
CREATE INDEX IF NOT EXISTS idx_categories_active ON categories(is_active);
CREATE INDEX IF NOT EXISTS idx_taste_profiles_active ON taste_profiles(is_active);
CREATE INDEX IF NOT EXISTS idx_roast_profiles_active ON roast_profiles(is_active);
CREATE INDEX IF NOT EXISTS idx_products_sku ON products(sku);
CREATE INDEX IF NOT EXISTS idx_products_active ON products(is_active);
CREATE INDEX IF NOT EXISTS idx_products_collections ON products USING GIN(collections);
CREATE INDEX IF NOT EXISTS idx_product_taste_product ON product_taste_profiles(product_id);
CREATE INDEX IF NOT EXISTS idx_product_roast_product ON product_roast_profiles(product_id);
CREATE INDEX IF NOT EXISTS idx_orders_user ON orders(user_id);
CREATE INDEX IF NOT EXISTS idx_orders_number ON orders(order_number);
CREATE INDEX IF NOT EXISTS idx_order_items_order ON order_items(order_id);

-- FUNCTIONS
CREATE OR REPLACE FUNCTION update_updated_at_column() RETURNS TRIGGER AS $$
BEGIN NEW.updated_at = NOW(); RETURN NEW; END; $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION generate_order_number() RETURNS TEXT AS $$
DECLARE new_number TEXT; counter INTEGER;
BEGIN SELECT COUNT(*) + 1 INTO counter FROM orders;
new_number := 'TEL-' || TO_CHAR(NOW(), 'YYYYMMDD') || '-' || LPAD(counter::TEXT, 4, '0');
RETURN new_number; END; $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION set_order_number() RETURNS TRIGGER AS $$
BEGIN IF NEW.order_number IS NULL THEN NEW.order_number := generate_order_number(); END IF; RETURN NEW; END; $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION decrement_inventory_on_order() RETURNS TRIGGER AS $$
BEGIN IF NEW.status = 'payment_received' AND OLD.status = 'pending_payment' THEN
UPDATE products p SET stock_quantity = stock_quantity - oi.quantity FROM order_items oi WHERE oi.order_id = NEW.id AND oi.product_id = p.id;
INSERT INTO inventory_transactions (product_id, quantity_change, transaction_type, reference_id)
SELECT oi.product_id, -oi.quantity, 'sale', NEW.id FROM order_items oi WHERE oi.order_id = NEW.id;
END IF; RETURN NEW; END; $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION is_admin() RETURNS BOOLEAN AS $$
SELECT EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'admin'); $$ LANGUAGE sql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION is_approved_wholesale() RETURNS BOOLEAN AS $$
SELECT EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'wholesale' AND approval_status = 'approved'); $$ LANGUAGE sql SECURITY DEFINER;

-- TRIGGERS
DROP TRIGGER IF EXISTS update_profiles_updated_at ON profiles;
CREATE TRIGGER update_profiles_updated_at BEFORE UPDATE ON profiles FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
DROP TRIGGER IF EXISTS update_categories_updated_at ON categories;
CREATE TRIGGER update_categories_updated_at BEFORE UPDATE ON categories FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
DROP TRIGGER IF EXISTS update_products_updated_at ON products;
CREATE TRIGGER update_products_updated_at BEFORE UPDATE ON products FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
DROP TRIGGER IF EXISTS update_orders_updated_at ON orders;
CREATE TRIGGER update_orders_updated_at BEFORE UPDATE ON orders FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
DROP TRIGGER IF EXISTS set_order_number_trigger ON orders;
CREATE TRIGGER set_order_number_trigger BEFORE INSERT ON orders FOR EACH ROW EXECUTE FUNCTION set_order_number();
DROP TRIGGER IF EXISTS decrement_inventory_trigger ON orders;
CREATE TRIGGER decrement_inventory_trigger AFTER UPDATE ON orders FOR EACH ROW EXECUTE FUNCTION decrement_inventory_on_order();

-- RLS
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE taste_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE roast_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE products ENABLE ROW LEVEL SECURITY;
ALTER TABLE product_taste_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE product_roast_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE product_graphs ENABLE ROW LEVEL SECURITY;
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE order_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE wishlist_items ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Users can view own profile" ON profiles;
CREATE POLICY "Users can view own profile" ON profiles FOR SELECT USING (auth.uid() = id);
DROP POLICY IF EXISTS "Admins can view all profiles" ON profiles;
CREATE POLICY "Admins can view all profiles" ON profiles FOR SELECT USING (is_admin());
DROP POLICY IF EXISTS "Users can insert own profile" ON profiles;
CREATE POLICY "Users can insert own profile" ON profiles FOR INSERT WITH CHECK (auth.uid() = id);

DROP POLICY IF EXISTS "Anyone can view active categories" ON categories;
CREATE POLICY "Anyone can view active categories" ON categories FOR SELECT USING (is_active = true OR is_admin());
DROP POLICY IF EXISTS "Admins can manage categories" ON categories;
CREATE POLICY "Admins can manage categories" ON categories FOR ALL USING (is_admin());

DROP POLICY IF EXISTS "Anyone can view taste profiles" ON taste_profiles;
CREATE POLICY "Anyone can view taste profiles" ON taste_profiles FOR SELECT USING (is_active = true OR is_admin());
DROP POLICY IF EXISTS "Admins can manage taste profiles" ON taste_profiles;
CREATE POLICY "Admins can manage taste profiles" ON taste_profiles FOR ALL USING (is_admin());

DROP POLICY IF EXISTS "Anyone can view roast profiles" ON roast_profiles;
CREATE POLICY "Anyone can view roast profiles" ON roast_profiles FOR SELECT USING (is_active = true OR is_admin());
DROP POLICY IF EXISTS "Admins can manage roast profiles" ON roast_profiles;
CREATE POLICY "Admins can manage roast profiles" ON roast_profiles FOR ALL USING (is_admin());

DROP POLICY IF EXISTS "Anyone can view active products" ON products;
CREATE POLICY "Anyone can view active products" ON products FOR SELECT USING (is_active = true OR is_admin());
DROP POLICY IF EXISTS "Admins can manage products" ON products;
CREATE POLICY "Admins can manage products" ON products FOR ALL USING (is_admin());

DROP POLICY IF EXISTS "Anyone can view product taste" ON product_taste_profiles;
CREATE POLICY "Anyone can view product taste" ON product_taste_profiles FOR SELECT USING (true);
DROP POLICY IF EXISTS "Admins manage product taste" ON product_taste_profiles;
CREATE POLICY "Admins manage product taste" ON product_taste_profiles FOR ALL USING (is_admin());

DROP POLICY IF EXISTS "Anyone can view product roast" ON product_roast_profiles;
CREATE POLICY "Anyone can view product roast" ON product_roast_profiles FOR SELECT USING (true);
DROP POLICY IF EXISTS "Admins manage product roast" ON product_roast_profiles;
CREATE POLICY "Admins manage product roast" ON product_roast_profiles FOR ALL USING (is_admin());

DROP POLICY IF EXISTS "Anyone can view graphs" ON product_graphs;
CREATE POLICY "Anyone can view graphs" ON product_graphs FOR SELECT USING (true);
DROP POLICY IF EXISTS "Admins manage graphs" ON product_graphs;
CREATE POLICY "Admins manage graphs" ON product_graphs FOR ALL USING (is_admin());

DROP POLICY IF EXISTS "Users view own orders" ON orders;
CREATE POLICY "Users view own orders" ON orders FOR SELECT USING (auth.uid() = user_id OR is_admin());
DROP POLICY IF EXISTS "Users create orders" ON orders;
CREATE POLICY "Users create orders" ON orders FOR INSERT WITH CHECK (auth.uid() = user_id);
DROP POLICY IF EXISTS "Admins manage orders" ON orders;
CREATE POLICY "Admins manage orders" ON orders FOR ALL USING (is_admin());

DROP POLICY IF EXISTS "Users view own items" ON order_items;
CREATE POLICY "Users view own items" ON order_items FOR SELECT USING (EXISTS (SELECT 1 FROM orders WHERE orders.id = order_items.order_id AND orders.user_id = auth.uid()) OR is_admin());

DROP POLICY IF EXISTS "Users manage wishlist" ON wishlist_items;
CREATE POLICY "Users manage wishlist" ON wishlist_items FOR ALL USING (auth.uid() = user_id);

-- COMPLETE
