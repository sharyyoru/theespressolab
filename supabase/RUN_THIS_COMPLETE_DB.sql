-- THE ESPRESSO LAB - COMPLETE DATABASE
-- COPY THIS ENTIRE FILE AND RUN IN SUPABASE SQL EDITOR

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

DO $$ BEGIN CREATE TYPE user_role AS ENUM ('customer', 'wholesale', 'admin'); EXCEPTION WHEN duplicate_object THEN null; END $$;
DO $$ BEGIN CREATE TYPE approval_status AS ENUM ('pending', 'approved', 'rejected'); EXCEPTION WHEN duplicate_object THEN null; END $$;
DO $$ BEGIN CREATE TYPE order_status AS ENUM ('pending_payment', 'payment_received', 'processing', 'qc_scheduled', 'qc_completed', 'shipped', 'delivered', 'cancelled', 'refunded'); EXCEPTION WHEN duplicate_object THEN null; END $$;
DO $$ BEGIN CREATE TYPE payment_method AS ENUM ('stripe', 'bank_transfer'); EXCEPTION WHEN duplicate_object THEN null; END $$;
DO $$ BEGIN CREATE TYPE booking_status AS ENUM ('pending', 'confirmed', 'cancelled', 'completed', 'rescheduled'); EXCEPTION WHEN duplicate_object THEN null; END $$;
DO $$ BEGIN CREATE TYPE qc_appointment_status AS ENUM ('requested', 'scheduled', 'in_progress', 'completed', 'cancelled'); EXCEPTION WHEN duplicate_object THEN null; END $$;
DO $$ BEGIN CREATE TYPE notification_type AS ENUM ('order_placed', 'order_approved', 'order_shipped', 'qc_scheduled', 'qc_completed', 'course_booked', 'wholesale_approved', 'wholesale_rejected'); EXCEPTION WHEN duplicate_object THEN null; END $$;

CREATE TABLE IF NOT EXISTS profiles (id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE, email TEXT UNIQUE NOT NULL, full_name TEXT, phone TEXT, role user_role DEFAULT 'customer' NOT NULL, approval_status approval_status DEFAULT 'pending', company_name TEXT, business_license TEXT, created_at TIMESTAMPTZ DEFAULT NOW(), updated_at TIMESTAMPTZ DEFAULT NOW());

CREATE TABLE IF NOT EXISTS categories (id UUID PRIMARY KEY DEFAULT uuid_generate_v4(), sanity_id TEXT UNIQUE NOT NULL, slug TEXT UNIQUE NOT NULL, title_en TEXT NOT NULL, title_ar TEXT NOT NULL, description_en TEXT, description_ar TEXT, is_active BOOLEAN DEFAULT true, sort_order INTEGER DEFAULT 0, created_at TIMESTAMPTZ DEFAULT NOW(), updated_at TIMESTAMPTZ DEFAULT NOW());

CREATE TABLE IF NOT EXISTS collections (id UUID PRIMARY KEY DEFAULT uuid_generate_v4(), sanity_id TEXT UNIQUE NOT NULL, slug TEXT UNIQUE NOT NULL, title_en TEXT NOT NULL, title_ar TEXT NOT NULL, description_en TEXT, description_ar TEXT, is_active BOOLEAN DEFAULT true, sort_order INTEGER DEFAULT 0, created_at TIMESTAMPTZ DEFAULT NOW(), updated_at TIMESTAMPTZ DEFAULT NOW());

CREATE TABLE IF NOT EXISTS taste_profiles (id UUID PRIMARY KEY DEFAULT uuid_generate_v4(), sanity_id TEXT UNIQUE NOT NULL, title_en TEXT NOT NULL, title_ar TEXT NOT NULL, is_active BOOLEAN DEFAULT true, sort_order INTEGER DEFAULT 0, created_at TIMESTAMPTZ DEFAULT NOW(), updated_at TIMESTAMPTZ DEFAULT NOW());

CREATE TABLE IF NOT EXISTS roast_profiles (id UUID PRIMARY KEY DEFAULT uuid_generate_v4(), sanity_id TEXT UNIQUE NOT NULL, title_en TEXT NOT NULL, title_ar TEXT NOT NULL, is_active BOOLEAN DEFAULT true, sort_order INTEGER DEFAULT 0, created_at TIMESTAMPTZ DEFAULT NOW(), updated_at TIMESTAMPTZ DEFAULT NOW());

CREATE TABLE IF NOT EXISTS products (id UUID PRIMARY KEY DEFAULT uuid_generate_v4(), sanity_id TEXT UNIQUE NOT NULL, sku TEXT UNIQUE NOT NULL, category_id UUID REFERENCES categories(id) ON DELETE SET NULL, title_en TEXT NOT NULL, title_ar TEXT NOT NULL, description_en TEXT, description_ar TEXT, short_description_en TEXT, short_description_ar TEXT, price DECIMAL(10, 2) NOT NULL, stock_quantity INTEGER DEFAULT 0 NOT NULL, low_stock_threshold INTEGER DEFAULT 10, is_active BOOLEAN DEFAULT true, is_wholesale_only BOOLEAN DEFAULT false, created_at TIMESTAMPTZ DEFAULT NOW(), updated_at TIMESTAMPTZ DEFAULT NOW(), CONSTRAINT positive_stock CHECK (stock_quantity >= 0), CONSTRAINT positive_price CHECK (price >= 0));

CREATE TABLE IF NOT EXISTS product_collections (id UUID PRIMARY KEY DEFAULT uuid_generate_v4(), product_id UUID REFERENCES products(id) ON DELETE CASCADE, collection_id UUID REFERENCES collections(id) ON DELETE CASCADE, created_at TIMESTAMPTZ DEFAULT NOW(), UNIQUE(product_id, collection_id));

CREATE TABLE IF NOT EXISTS product_taste_profiles (id UUID PRIMARY KEY DEFAULT uuid_generate_v4(), product_id UUID REFERENCES products(id) ON DELETE CASCADE, taste_profile_id UUID REFERENCES taste_profiles(id) ON DELETE CASCADE, created_at TIMESTAMPTZ DEFAULT NOW(), UNIQUE(product_id, taste_profile_id));

CREATE TABLE IF NOT EXISTS product_roast_profiles (id UUID PRIMARY KEY DEFAULT uuid_generate_v4(), product_id UUID REFERENCES products(id) ON DELETE CASCADE, roast_profile_id UUID REFERENCES roast_profiles(id) ON DELETE CASCADE, created_at TIMESTAMPTZ DEFAULT NOW(), UNIQUE(product_id, roast_profile_id));

CREATE TABLE IF NOT EXISTS product_graph_1 (id UUID PRIMARY KEY DEFAULT uuid_generate_v4(), product_id UUID REFERENCES products(id) ON DELETE CASCADE, graph_name_en TEXT DEFAULT 'Acidity vs Body', graph_name_ar TEXT DEFAULT 'الحموضة مقابل القوام', value_x DECIMAL(5, 2) NOT NULL CHECK (value_x >= 0 AND value_x <= 10), value_y DECIMAL(5, 2) NOT NULL CHECK (value_y >= 0 AND value_y <= 10), label_x_en TEXT DEFAULT 'Acidity', label_x_ar TEXT DEFAULT 'الحموضة', label_y_en TEXT DEFAULT 'Body', label_y_ar TEXT DEFAULT 'القوام', created_at TIMESTAMPTZ DEFAULT NOW(), updated_at TIMESTAMPTZ DEFAULT NOW(), UNIQUE(product_id));

CREATE TABLE IF NOT EXISTS product_graph_2 (id UUID PRIMARY KEY DEFAULT uuid_generate_v4(), product_id UUID REFERENCES products(id) ON DELETE CASCADE, graph_name_en TEXT DEFAULT 'Sweetness vs Bitterness', graph_name_ar TEXT DEFAULT 'الحلاوة مقابل المرارة', value_x DECIMAL(5, 2) NOT NULL CHECK (value_x >= 0 AND value_x <= 10), value_y DECIMAL(5, 2) NOT NULL CHECK (value_y >= 0 AND value_y <= 10), label_x_en TEXT DEFAULT 'Sweetness', label_x_ar TEXT DEFAULT 'الحلاوة', label_y_en TEXT DEFAULT 'Bitterness', label_y_ar TEXT DEFAULT 'المرارة', created_at TIMESTAMPTZ DEFAULT NOW(), updated_at TIMESTAMPTZ DEFAULT NOW(), UNIQUE(product_id));

CREATE TABLE IF NOT EXISTS product_graph_3 (id UUID PRIMARY KEY DEFAULT uuid_generate_v4(), product_id UUID REFERENCES products(id) ON DELETE CASCADE, graph_name_en TEXT DEFAULT 'Aroma vs Aftertaste', graph_name_ar TEXT DEFAULT 'الرائحة مقابل الطعم المتبقي', value_x DECIMAL(5, 2) NOT NULL CHECK (value_x >= 0 AND value_x <= 10), value_y DECIMAL(5, 2) NOT NULL CHECK (value_y >= 0 AND value_y <= 10), label_x_en TEXT DEFAULT 'Aroma', label_x_ar TEXT DEFAULT 'الرائحة', label_y_en TEXT DEFAULT 'Aftertaste', label_y_ar TEXT DEFAULT 'الطعم المتبقي', created_at TIMESTAMPTZ DEFAULT NOW(), updated_at TIMESTAMPTZ DEFAULT NOW(), UNIQUE(product_id));

CREATE TABLE IF NOT EXISTS product_variants (id UUID PRIMARY KEY DEFAULT uuid_generate_v4(), product_id UUID REFERENCES products(id) ON DELETE CASCADE, sanity_id TEXT, sku TEXT UNIQUE NOT NULL, title_en TEXT, title_ar TEXT, price_adjustment DECIMAL(10, 2) DEFAULT 0, stock_quantity INTEGER DEFAULT 0 NOT NULL, is_active BOOLEAN DEFAULT true, created_at TIMESTAMPTZ DEFAULT NOW(), updated_at TIMESTAMPTZ DEFAULT NOW(), CONSTRAINT positive_variant_stock CHECK (stock_quantity >= 0));

CREATE TABLE IF NOT EXISTS inventory_transactions (id UUID PRIMARY KEY DEFAULT uuid_generate_v4(), product_id UUID REFERENCES products(id) ON DELETE CASCADE, variant_id UUID REFERENCES product_variants(id) ON DELETE CASCADE, quantity_change INTEGER NOT NULL, transaction_type TEXT NOT NULL, reference_id UUID, notes TEXT, created_by UUID REFERENCES profiles(id), created_at TIMESTAMPTZ DEFAULT NOW());

CREATE TABLE IF NOT EXISTS courses (id UUID PRIMARY KEY DEFAULT uuid_generate_v4(), sanity_id TEXT UNIQUE NOT NULL, title_en TEXT NOT NULL, title_ar TEXT NOT NULL, description_en TEXT, description_ar TEXT, short_description_en TEXT, short_description_ar TEXT, price DECIMAL(10, 2) NOT NULL, duration_minutes INTEGER, max_participants INTEGER DEFAULT 10, is_active BOOLEAN DEFAULT true, created_at TIMESTAMPTZ DEFAULT NOW(), updated_at TIMESTAMPTZ DEFAULT NOW());

CREATE TABLE IF NOT EXISTS course_schedules (id UUID PRIMARY KEY DEFAULT uuid_generate_v4(), course_id UUID REFERENCES courses(id) ON DELETE CASCADE, start_time TIMESTAMPTZ NOT NULL, end_time TIMESTAMPTZ NOT NULL, available_slots INTEGER NOT NULL, is_active BOOLEAN DEFAULT true, created_at TIMESTAMPTZ DEFAULT NOW(), updated_at TIMESTAMPTZ DEFAULT NOW(), CONSTRAINT valid_time_range CHECK (end_time > start_time), CONSTRAINT positive_slots CHECK (available_slots >= 0));

CREATE TABLE IF NOT EXISTS course_bookings (id UUID PRIMARY KEY DEFAULT uuid_generate_v4(), course_id UUID REFERENCES courses(id) ON DELETE CASCADE, schedule_id UUID REFERENCES course_schedules(id) ON DELETE CASCADE, user_id UUID REFERENCES profiles(id) ON DELETE CASCADE, participants_count INTEGER DEFAULT 1, status booking_status DEFAULT 'pending', payment_status TEXT DEFAULT 'pending', total_amount DECIMAL(10, 2) NOT NULL, notes TEXT, admin_notes TEXT, created_at TIMESTAMPTZ DEFAULT NOW(), updated_at TIMESTAMPTZ DEFAULT NOW(), CONSTRAINT positive_participants CHECK (participants_count > 0));

CREATE TABLE IF NOT EXISTS orders (id UUID PRIMARY KEY DEFAULT uuid_generate_v4(), order_number TEXT UNIQUE NOT NULL, user_id UUID REFERENCES profiles(id) ON DELETE SET NULL, status order_status DEFAULT 'pending_payment', payment_method payment_method NOT NULL, payment_status TEXT DEFAULT 'pending', stripe_payment_intent_id TEXT, bank_transfer_receipt_url TEXT, subtotal DECIMAL(10, 2) NOT NULL, tax DECIMAL(10, 2) DEFAULT 0, shipping_fee DECIMAL(10, 2) DEFAULT 0, total_amount DECIMAL(10, 2) NOT NULL, shipping_full_name TEXT NOT NULL, shipping_phone TEXT NOT NULL, shipping_address_line1 TEXT NOT NULL, shipping_address_line2 TEXT, shipping_city TEXT NOT NULL, shipping_state TEXT, shipping_postal_code TEXT, shipping_country TEXT NOT NULL, tracking_number TEXT, shipped_at TIMESTAMPTZ, delivered_at TIMESTAMPTZ, notes TEXT, admin_notes TEXT, created_at TIMESTAMPTZ DEFAULT NOW(), updated_at TIMESTAMPTZ DEFAULT NOW(), CONSTRAINT positive_amounts CHECK (subtotal >= 0 AND tax >= 0 AND shipping_fee >= 0 AND total_amount >= 0));

CREATE TABLE IF NOT EXISTS order_items (id UUID PRIMARY KEY DEFAULT uuid_generate_v4(), order_id UUID REFERENCES orders(id) ON DELETE CASCADE, product_id UUID REFERENCES products(id) ON DELETE SET NULL, variant_id UUID REFERENCES product_variants(id) ON DELETE SET NULL, product_name TEXT NOT NULL, product_sku TEXT NOT NULL, variant_details JSONB, quantity INTEGER NOT NULL, unit_price DECIMAL(10, 2) NOT NULL, total_price DECIMAL(10, 2) NOT NULL, created_at TIMESTAMPTZ DEFAULT NOW(), CONSTRAINT positive_quantity CHECK (quantity > 0), CONSTRAINT positive_prices CHECK (unit_price >= 0 AND total_price >= 0));

CREATE TABLE IF NOT EXISTS qc_appointments (id UUID PRIMARY KEY DEFAULT uuid_generate_v4(), order_id UUID REFERENCES orders(id) ON DELETE CASCADE, user_id UUID REFERENCES profiles(id) ON DELETE CASCADE, status qc_appointment_status DEFAULT 'requested', scheduled_date TIMESTAMPTZ, completed_date TIMESTAMPTZ, customer_notes TEXT, admin_notes TEXT, created_at TIMESTAMPTZ DEFAULT NOW(), updated_at TIMESTAMPTZ DEFAULT NOW());

CREATE TABLE IF NOT EXISTS qc_reports (id UUID PRIMARY KEY DEFAULT uuid_generate_v4(), appointment_id UUID REFERENCES qc_appointments(id) ON DELETE CASCADE, order_id UUID REFERENCES orders(id) ON DELETE CASCADE, inspector_id UUID REFERENCES profiles(id) ON DELETE SET NULL, overall_rating INTEGER CHECK (overall_rating >= 1 AND overall_rating <= 5), overall_notes TEXT, images_urls TEXT[], passed BOOLEAN, completed_at TIMESTAMPTZ DEFAULT NOW(), created_at TIMESTAMPTZ DEFAULT NOW(), updated_at TIMESTAMPTZ DEFAULT NOW());

CREATE TABLE IF NOT EXISTS qc_answers (id UUID PRIMARY KEY DEFAULT uuid_generate_v4(), report_id UUID REFERENCES qc_reports(id) ON DELETE CASCADE, question_sanity_id TEXT NOT NULL, question_text TEXT NOT NULL, answer_value TEXT, rating INTEGER CHECK (rating >= 1 AND rating <= 5), notes TEXT, created_at TIMESTAMPTZ DEFAULT NOW());

CREATE TABLE IF NOT EXISTS qc_feedback (id UUID PRIMARY KEY DEFAULT uuid_generate_v4(), report_id UUID REFERENCES qc_reports(id) ON DELETE CASCADE, user_id UUID REFERENCES profiles(id) ON DELETE CASCADE, rating INTEGER CHECK (rating >= 1 AND rating <= 5), comments TEXT, created_at TIMESTAMPTZ DEFAULT NOW());

CREATE TABLE IF NOT EXISTS wishlist_items (id UUID PRIMARY KEY DEFAULT uuid_generate_v4(), user_id UUID REFERENCES profiles(id) ON DELETE CASCADE, product_id UUID REFERENCES products(id) ON DELETE CASCADE, variant_id UUID REFERENCES product_variants(id) ON DELETE CASCADE, created_at TIMESTAMPTZ DEFAULT NOW(), UNIQUE(user_id, product_id, variant_id));

CREATE TABLE IF NOT EXISTS notifications (id UUID PRIMARY KEY DEFAULT uuid_generate_v4(), user_id UUID REFERENCES profiles(id) ON DELETE CASCADE, type notification_type NOT NULL, title TEXT NOT NULL, message TEXT NOT NULL, reference_id UUID, is_read BOOLEAN DEFAULT false, email_sent BOOLEAN DEFAULT false, created_at TIMESTAMPTZ DEFAULT NOW());

CREATE INDEX IF NOT EXISTS idx_profiles_role ON profiles(role);
CREATE INDEX IF NOT EXISTS idx_categories_slug ON categories(slug);
CREATE INDEX IF NOT EXISTS idx_collections_slug ON collections(slug);
CREATE INDEX IF NOT EXISTS idx_products_sku ON products(sku);
CREATE INDEX IF NOT EXISTS idx_products_active ON products(is_active);
CREATE INDEX IF NOT EXISTS idx_product_collections_product ON product_collections(product_id);
CREATE INDEX IF NOT EXISTS idx_product_taste_product ON product_taste_profiles(product_id);
CREATE INDEX IF NOT EXISTS idx_product_roast_product ON product_roast_profiles(product_id);
CREATE INDEX IF NOT EXISTS idx_graph_1_product ON product_graph_1(product_id);
CREATE INDEX IF NOT EXISTS idx_graph_2_product ON product_graph_2(product_id);
CREATE INDEX IF NOT EXISTS idx_graph_3_product ON product_graph_3(product_id);
CREATE INDEX IF NOT EXISTS idx_orders_user ON orders(user_id);
CREATE INDEX IF NOT EXISTS idx_orders_number ON orders(order_number);

CREATE OR REPLACE FUNCTION update_updated_at_column() RETURNS TRIGGER AS $$ BEGIN NEW.updated_at = NOW(); RETURN NEW; END; $$ LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION generate_order_number() RETURNS TEXT AS $$ DECLARE new_number TEXT; counter INTEGER; BEGIN SELECT COUNT(*) + 1 INTO counter FROM orders; new_number := 'TEL-' || TO_CHAR(NOW(), 'YYYYMMDD') || '-' || LPAD(counter::TEXT, 4, '0'); RETURN new_number; END; $$ LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION set_order_number() RETURNS TRIGGER AS $$ BEGIN IF NEW.order_number IS NULL THEN NEW.order_number := generate_order_number(); END IF; RETURN NEW; END; $$ LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION decrement_inventory_on_order() RETURNS TRIGGER AS $$ BEGIN IF NEW.status = 'payment_received' AND OLD.status = 'pending_payment' THEN UPDATE products p SET stock_quantity = stock_quantity - oi.quantity FROM order_items oi WHERE oi.order_id = NEW.id AND oi.product_id = p.id; INSERT INTO inventory_transactions (product_id, quantity_change, transaction_type, reference_id) SELECT oi.product_id, -oi.quantity, 'sale', NEW.id FROM order_items oi WHERE oi.order_id = NEW.id; END IF; RETURN NEW; END; $$ LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION is_admin() RETURNS BOOLEAN AS $$ SELECT EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'admin'); $$ LANGUAGE sql SECURITY DEFINER;
CREATE OR REPLACE FUNCTION is_approved_wholesale() RETURNS BOOLEAN AS $$ SELECT EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'wholesale' AND approval_status = 'approved'); $$ LANGUAGE sql SECURITY DEFINER;

DROP TRIGGER IF EXISTS update_products_updated_at ON products; CREATE TRIGGER update_products_updated_at BEFORE UPDATE ON products FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
DROP TRIGGER IF EXISTS update_orders_updated_at ON orders; CREATE TRIGGER update_orders_updated_at BEFORE UPDATE ON orders FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
DROP TRIGGER IF EXISTS set_order_number_trigger ON orders; CREATE TRIGGER set_order_number_trigger BEFORE INSERT ON orders FOR EACH ROW EXECUTE FUNCTION set_order_number();
DROP TRIGGER IF EXISTS decrement_inventory_trigger ON orders; CREATE TRIGGER decrement_inventory_trigger AFTER UPDATE ON orders FOR EACH ROW EXECUTE FUNCTION decrement_inventory_on_order();

ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE collections ENABLE ROW LEVEL SECURITY;
ALTER TABLE taste_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE roast_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE products ENABLE ROW LEVEL SECURITY;
ALTER TABLE product_collections ENABLE ROW LEVEL SECURITY;
ALTER TABLE product_taste_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE product_roast_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE product_graph_1 ENABLE ROW LEVEL SECURITY;
ALTER TABLE product_graph_2 ENABLE ROW LEVEL SECURITY;
ALTER TABLE product_graph_3 ENABLE ROW LEVEL SECURITY;
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE wishlist_items ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "View active categories" ON categories; CREATE POLICY "View active categories" ON categories FOR SELECT USING (is_active = true OR is_admin());
DROP POLICY IF EXISTS "Admins manage categories" ON categories; CREATE POLICY "Admins manage categories" ON categories FOR ALL USING (is_admin());
DROP POLICY IF EXISTS "View active collections" ON collections; CREATE POLICY "View active collections" ON collections FOR SELECT USING (is_active = true OR is_admin());
DROP POLICY IF EXISTS "Admins manage collections" ON collections; CREATE POLICY "Admins manage collections" ON collections FOR ALL USING (is_admin());
DROP POLICY IF EXISTS "View taste profiles" ON taste_profiles; CREATE POLICY "View taste profiles" ON taste_profiles FOR SELECT USING (is_active = true OR is_admin());
DROP POLICY IF EXISTS "Admins manage taste" ON taste_profiles; CREATE POLICY "Admins manage taste" ON taste_profiles FOR ALL USING (is_admin());
DROP POLICY IF EXISTS "View roast profiles" ON roast_profiles; CREATE POLICY "View roast profiles" ON roast_profiles FOR SELECT USING (is_active = true OR is_admin());
DROP POLICY IF EXISTS "Admins manage roast" ON roast_profiles; CREATE POLICY "Admins manage roast" ON roast_profiles FOR ALL USING (is_admin());
DROP POLICY IF EXISTS "View active products" ON products; CREATE POLICY "View active products" ON products FOR SELECT USING (is_active = true OR is_admin());
DROP POLICY IF EXISTS "Admins manage products" ON products; CREATE POLICY "Admins manage products" ON products FOR ALL USING (is_admin());
DROP POLICY IF EXISTS "View product collections" ON product_collections; CREATE POLICY "View product collections" ON product_collections FOR SELECT USING (true);
DROP POLICY IF EXISTS "Admins manage product collections" ON product_collections; CREATE POLICY "Admins manage product collections" ON product_collections FOR ALL USING (is_admin());
DROP POLICY IF EXISTS "View product taste" ON product_taste_profiles; CREATE POLICY "View product taste" ON product_taste_profiles FOR SELECT USING (true);
DROP POLICY IF EXISTS "Admins manage product taste" ON product_taste_profiles; CREATE POLICY "Admins manage product taste" ON product_taste_profiles FOR ALL USING (is_admin());
DROP POLICY IF EXISTS "View product roast" ON product_roast_profiles; CREATE POLICY "View product roast" ON product_roast_profiles FOR SELECT USING (true);
DROP POLICY IF EXISTS "Admins manage product roast" ON product_roast_profiles; CREATE POLICY "Admins manage product roast" ON product_roast_profiles FOR ALL USING (is_admin());
DROP POLICY IF EXISTS "View graph 1" ON product_graph_1; CREATE POLICY "View graph 1" ON product_graph_1 FOR SELECT USING (true);
DROP POLICY IF EXISTS "Admins manage graph 1" ON product_graph_1; CREATE POLICY "Admins manage graph 1" ON product_graph_1 FOR ALL USING (is_admin());
DROP POLICY IF EXISTS "View graph 2" ON product_graph_2; CREATE POLICY "View graph 2" ON product_graph_2 FOR SELECT USING (true);
DROP POLICY IF EXISTS "Admins manage graph 2" ON product_graph_2; CREATE POLICY "Admins manage graph 2" ON product_graph_2 FOR ALL USING (is_admin());
DROP POLICY IF EXISTS "View graph 3" ON product_graph_3; CREATE POLICY "View graph 3" ON product_graph_3 FOR SELECT USING (true);
DROP POLICY IF EXISTS "Admins manage graph 3" ON product_graph_3; CREATE POLICY "Admins manage graph 3" ON product_graph_3 FOR ALL USING (is_admin());
DROP POLICY IF EXISTS "Users view own orders" ON orders; CREATE POLICY "Users view own orders" ON orders FOR SELECT USING (auth.uid() = user_id OR is_admin());
DROP POLICY IF EXISTS "Users create orders" ON orders; CREATE POLICY "Users create orders" ON orders FOR INSERT WITH CHECK (auth.uid() = user_id);
DROP POLICY IF EXISTS "Admins manage orders" ON orders; CREATE POLICY "Admins manage orders" ON orders FOR ALL USING (is_admin());
DROP POLICY IF EXISTS "Users manage wishlist" ON wishlist_items; CREATE POLICY "Users manage wishlist" ON wishlist_items FOR ALL USING (auth.uid() = user_id);

ALTER PUBLICATION supabase_realtime ADD TABLE products;
ALTER PUBLICATION supabase_realtime ADD TABLE orders;
