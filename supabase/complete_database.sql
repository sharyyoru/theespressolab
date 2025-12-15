-- =====================================================
-- THE ESPRESSO LAB - COMPLETE DATABASE SETUP
-- =====================================================
-- Run this entire file in Supabase SQL Editor
-- This creates all tables, triggers, functions, and RLS policies
-- =====================================================

-- Enable necessary extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- =====================================================
-- ENUMS
-- =====================================================

CREATE TYPE user_role AS ENUM ('customer', 'wholesale', 'admin');
CREATE TYPE approval_status AS ENUM ('pending', 'approved', 'rejected');
CREATE TYPE collection_type AS ENUM (
    'new_arrivals', 'coffee', 'instant', 'drip', 'merch',
    'wholesale_instant', 'rare_lots', 'reserve_lots', 
    'tel_signature', 's90', 'specialty_gadgets'
);
CREATE TYPE order_status AS ENUM (
    'pending_payment', 'payment_received', 'processing', 
    'qc_scheduled', 'qc_completed', 'shipped', 'delivered', 
    'cancelled', 'refunded'
);
CREATE TYPE payment_method AS ENUM ('stripe', 'bank_transfer');
CREATE TYPE booking_status AS ENUM ('pending', 'confirmed', 'cancelled', 'completed', 'rescheduled');
CREATE TYPE qc_appointment_status AS ENUM (
    'requested', 'scheduled', 'in_progress', 'completed', 'cancelled'
);
CREATE TYPE notification_type AS ENUM (
    'order_placed', 'order_approved', 'order_shipped', 
    'qc_scheduled', 'qc_completed', 'course_booked', 
    'wholesale_approved', 'wholesale_rejected'
);

-- =====================================================
-- TABLES
-- =====================================================

-- Profiles
CREATE TABLE profiles (
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

-- Categories
CREATE TABLE categories (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    sanity_id TEXT UNIQUE NOT NULL,
    slug TEXT UNIQUE NOT NULL,
    is_active BOOLEAN DEFAULT true,
    sort_order INTEGER DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Products
CREATE TABLE products (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    sanity_id TEXT UNIQUE NOT NULL,
    sku TEXT UNIQUE NOT NULL,
    category_id UUID REFERENCES categories(id) ON DELETE SET NULL,
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

-- Product Variants
CREATE TABLE product_variants (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    product_id UUID REFERENCES products(id) ON DELETE CASCADE,
    sanity_id TEXT,
    sku TEXT UNIQUE NOT NULL,
    price_adjustment DECIMAL(10, 2) DEFAULT 0,
    stock_quantity INTEGER DEFAULT 0 NOT NULL,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    CONSTRAINT positive_variant_stock CHECK (stock_quantity >= 0)
);

-- Inventory Transactions
CREATE TABLE inventory_transactions (
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

-- Courses
CREATE TABLE courses (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    sanity_id TEXT UNIQUE NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    duration_minutes INTEGER,
    max_participants INTEGER DEFAULT 10,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Course Schedules
CREATE TABLE course_schedules (
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

-- Course Bookings
CREATE TABLE course_bookings (
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

-- Orders
CREATE TABLE orders (
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
    CONSTRAINT positive_amounts CHECK (
        subtotal >= 0 AND tax >= 0 AND shipping_fee >= 0 AND total_amount >= 0
    )
);

-- Order Items
CREATE TABLE order_items (
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

-- QC Appointments
CREATE TABLE qc_appointments (
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

-- QC Reports
CREATE TABLE qc_reports (
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

-- QC Answers
CREATE TABLE qc_answers (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    report_id UUID REFERENCES qc_reports(id) ON DELETE CASCADE,
    question_sanity_id TEXT NOT NULL,
    question_text TEXT NOT NULL,
    answer_value TEXT,
    rating INTEGER CHECK (rating >= 1 AND rating <= 5),
    notes TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- QC Feedback
CREATE TABLE qc_feedback (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    report_id UUID REFERENCES qc_reports(id) ON DELETE CASCADE,
    user_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
    rating INTEGER CHECK (rating >= 1 AND rating <= 5),
    comments TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Wishlist
CREATE TABLE wishlist_items (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
    product_id UUID REFERENCES products(id) ON DELETE CASCADE,
    variant_id UUID REFERENCES product_variants(id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(user_id, product_id, variant_id)
);

-- Notifications
CREATE TABLE notifications (
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

-- =====================================================
-- INDEXES
-- =====================================================

CREATE INDEX idx_profiles_role ON profiles(role);
CREATE INDEX idx_profiles_approval_status ON profiles(approval_status);
CREATE INDEX idx_products_category ON products(category_id);
CREATE INDEX idx_products_sku ON products(sku);
CREATE INDEX idx_products_active ON products(is_active);
CREATE INDEX idx_products_stock ON products(stock_quantity);
CREATE INDEX idx_products_collections ON products USING GIN(collections);
CREATE INDEX idx_orders_user ON orders(user_id);
CREATE INDEX idx_orders_status ON orders(status);
CREATE INDEX idx_orders_number ON orders(order_number);
CREATE INDEX idx_orders_created ON orders(created_at DESC);
CREATE INDEX idx_orders_payment_status ON orders(payment_status);
CREATE INDEX idx_order_items_order ON order_items(order_id);
CREATE INDEX idx_order_items_product ON order_items(product_id);
CREATE INDEX idx_qc_appointments_order ON qc_appointments(order_id);
CREATE INDEX idx_qc_appointments_user ON qc_appointments(user_id);
CREATE INDEX idx_qc_appointments_status ON qc_appointments(status);
CREATE INDEX idx_qc_reports_appointment ON qc_reports(appointment_id);
CREATE INDEX idx_qc_answers_report ON qc_answers(report_id);
CREATE INDEX idx_course_bookings_user ON course_bookings(user_id);
CREATE INDEX idx_course_bookings_schedule ON course_bookings(schedule_id);
CREATE INDEX idx_course_schedules_course ON course_schedules(course_id);
CREATE INDEX idx_course_schedules_time ON course_schedules(start_time);
CREATE INDEX idx_wishlist_user ON wishlist_items(user_id);
CREATE INDEX idx_notifications_user ON notifications(user_id);
CREATE INDEX idx_notifications_unread ON notifications(user_id, is_read);

-- =====================================================
-- FUNCTIONS & TRIGGERS
-- =====================================================

-- Update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_profiles_updated_at BEFORE UPDATE ON profiles
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_categories_updated_at BEFORE UPDATE ON categories
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_products_updated_at BEFORE UPDATE ON products
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_product_variants_updated_at BEFORE UPDATE ON product_variants
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_orders_updated_at BEFORE UPDATE ON orders
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_qc_appointments_updated_at BEFORE UPDATE ON qc_appointments
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_qc_reports_updated_at BEFORE UPDATE ON qc_reports
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Generate order number
CREATE OR REPLACE FUNCTION generate_order_number()
RETURNS TEXT AS $$
DECLARE
    new_number TEXT;
    counter INTEGER;
BEGIN
    SELECT COUNT(*) + 1 INTO counter FROM orders;
    new_number := 'TEL-' || TO_CHAR(NOW(), 'YYYYMMDD') || '-' || LPAD(counter::TEXT, 4, '0');
    RETURN new_number;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION set_order_number()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.order_number IS NULL THEN
        NEW.order_number := generate_order_number();
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER set_order_number_trigger BEFORE INSERT ON orders
    FOR EACH ROW EXECUTE FUNCTION set_order_number();

-- Decrement inventory on order
CREATE OR REPLACE FUNCTION decrement_inventory_on_order()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.status = 'payment_received' AND OLD.status = 'pending_payment' THEN
        UPDATE products p
        SET stock_quantity = stock_quantity - oi.quantity
        FROM order_items oi
        WHERE oi.order_id = NEW.id 
        AND oi.product_id = p.id
        AND oi.variant_id IS NULL;
        
        UPDATE product_variants pv
        SET stock_quantity = stock_quantity - oi.quantity
        FROM order_items oi
        WHERE oi.order_id = NEW.id 
        AND oi.variant_id = pv.id;
        
        INSERT INTO inventory_transactions (product_id, variant_id, quantity_change, transaction_type, reference_id)
        SELECT 
            oi.product_id,
            oi.variant_id,
            -oi.quantity,
            'sale',
            NEW.id
        FROM order_items oi
        WHERE oi.order_id = NEW.id;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER decrement_inventory_trigger AFTER UPDATE ON orders
    FOR EACH ROW EXECUTE FUNCTION decrement_inventory_on_order();

-- Decrement course slots
CREATE OR REPLACE FUNCTION decrement_course_slots()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.status = 'confirmed' AND (OLD IS NULL OR OLD.status != 'confirmed') THEN
        UPDATE course_schedules
        SET available_slots = available_slots - NEW.participants_count
        WHERE id = NEW.schedule_id;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER decrement_course_slots_trigger AFTER INSERT OR UPDATE ON course_bookings
    FOR EACH ROW EXECUTE FUNCTION decrement_course_slots();

-- =====================================================
-- ROW LEVEL SECURITY
-- =====================================================

ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE products ENABLE ROW LEVEL SECURITY;
ALTER TABLE product_variants ENABLE ROW LEVEL SECURITY;
ALTER TABLE inventory_transactions ENABLE ROW LEVEL SECURITY;
ALTER TABLE courses ENABLE ROW LEVEL SECURITY;
ALTER TABLE course_schedules ENABLE ROW LEVEL SECURITY;
ALTER TABLE course_bookings ENABLE ROW LEVEL SECURITY;
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE order_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE qc_appointments ENABLE ROW LEVEL SECURITY;
ALTER TABLE qc_reports ENABLE ROW LEVEL SECURITY;
ALTER TABLE qc_answers ENABLE ROW LEVEL SECURITY;
ALTER TABLE qc_feedback ENABLE ROW LEVEL SECURITY;
ALTER TABLE wishlist_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE notifications ENABLE ROW LEVEL SECURITY;

-- Helper functions
CREATE OR REPLACE FUNCTION get_user_role()
RETURNS user_role AS $$
    SELECT role FROM profiles WHERE id = auth.uid();
$$ LANGUAGE sql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION is_admin()
RETURNS BOOLEAN AS $$
    SELECT EXISTS (
        SELECT 1 FROM profiles 
        WHERE id = auth.uid() AND role = 'admin'
    );
$$ LANGUAGE sql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION is_approved_wholesale()
RETURNS BOOLEAN AS $$
    SELECT EXISTS (
        SELECT 1 FROM profiles 
        WHERE id = auth.uid() 
        AND role = 'wholesale' 
        AND approval_status = 'approved'
    );
$$ LANGUAGE sql SECURITY DEFINER;

-- Profiles policies
CREATE POLICY "Users can view own profile" ON profiles FOR SELECT USING (auth.uid() = id);
CREATE POLICY "Admins can view all profiles" ON profiles FOR SELECT USING (is_admin());
CREATE POLICY "Users can update own profile" ON profiles FOR UPDATE USING (auth.uid() = id);
CREATE POLICY "Admins can update any profile" ON profiles FOR UPDATE USING (is_admin());
CREATE POLICY "Users can insert own profile" ON profiles FOR INSERT WITH CHECK (auth.uid() = id);

-- Categories policies
CREATE POLICY "Anyone can view active categories" ON categories FOR SELECT USING (is_active = true OR is_admin());
CREATE POLICY "Admins can manage categories" ON categories FOR ALL USING (is_admin());

-- Products policies
CREATE POLICY "Anyone can view active products" ON products FOR SELECT USING (is_active = true OR is_admin());
CREATE POLICY "Admins can manage products" ON products FOR ALL USING (is_admin());

-- Product variants policies
CREATE POLICY "Anyone can view active variants" ON product_variants FOR SELECT USING (is_active = true OR is_admin());
CREATE POLICY "Admins can manage variants" ON product_variants FOR ALL USING (is_admin());

-- Inventory transactions policies
CREATE POLICY "Admins can view inventory transactions" ON inventory_transactions FOR SELECT USING (is_admin());
CREATE POLICY "System can insert inventory transactions" ON inventory_transactions FOR INSERT WITH CHECK (true);

-- Courses policies
CREATE POLICY "Anyone can view active courses" ON courses FOR SELECT USING (is_active = true OR is_admin());
CREATE POLICY "Admins can manage courses" ON courses FOR ALL USING (is_admin());

-- Course schedules policies
CREATE POLICY "Anyone can view available schedules" ON course_schedules FOR SELECT USING ((is_active = true AND available_slots > 0) OR is_admin());
CREATE POLICY "Admins can manage schedules" ON course_schedules FOR ALL USING (is_admin());

-- Course bookings policies
CREATE POLICY "Users can view own bookings" ON course_bookings FOR SELECT USING (auth.uid() = user_id OR is_admin());
CREATE POLICY "Users can create bookings" ON course_bookings FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can update own bookings" ON course_bookings FOR UPDATE USING (auth.uid() = user_id AND status = 'pending');
CREATE POLICY "Admins can manage all bookings" ON course_bookings FOR ALL USING (is_admin());

-- Orders policies
CREATE POLICY "Users can view own orders" ON orders FOR SELECT USING (auth.uid() = user_id OR is_admin());
CREATE POLICY "Users can create orders" ON orders FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can update own pending orders" ON orders FOR UPDATE USING (auth.uid() = user_id AND status IN ('pending_payment', 'payment_received'));
CREATE POLICY "Admins can manage all orders" ON orders FOR ALL USING (is_admin());

-- Order items policies
CREATE POLICY "Users can view own order items" ON order_items FOR SELECT USING (EXISTS (SELECT 1 FROM orders WHERE orders.id = order_items.order_id AND orders.user_id = auth.uid()) OR is_admin());
CREATE POLICY "Users can insert own order items" ON order_items FOR INSERT WITH CHECK (EXISTS (SELECT 1 FROM orders WHERE orders.id = order_items.order_id AND orders.user_id = auth.uid()));
CREATE POLICY "Admins can manage all order items" ON order_items FOR ALL USING (is_admin());

-- QC appointments policies
CREATE POLICY "Users can view own QC appointments" ON qc_appointments FOR SELECT USING (auth.uid() = user_id OR is_admin());
CREATE POLICY "Wholesale can create QC appointments" ON qc_appointments FOR INSERT WITH CHECK (auth.uid() = user_id AND is_approved_wholesale());
CREATE POLICY "Users can update own appointments" ON qc_appointments FOR UPDATE USING (auth.uid() = user_id AND status = 'requested');
CREATE POLICY "Admins can manage all QC appointments" ON qc_appointments FOR ALL USING (is_admin());

-- QC reports policies
CREATE POLICY "Users can view own QC reports" ON qc_reports FOR SELECT USING (EXISTS (SELECT 1 FROM orders WHERE orders.id = qc_reports.order_id AND orders.user_id = auth.uid()) OR is_admin());
CREATE POLICY "Admins can manage QC reports" ON qc_reports FOR ALL USING (is_admin());

-- QC answers policies
CREATE POLICY "Users can view own QC answers" ON qc_answers FOR SELECT USING (EXISTS (SELECT 1 FROM qc_reports JOIN orders ON orders.id = qc_reports.order_id WHERE qc_reports.id = qc_answers.report_id AND orders.user_id = auth.uid()) OR is_admin());
CREATE POLICY "Admins can manage QC answers" ON qc_answers FOR ALL USING (is_admin());

-- QC feedback policies
CREATE POLICY "Users can view own QC feedback" ON qc_feedback FOR SELECT USING (auth.uid() = user_id OR is_admin());
CREATE POLICY "Users can create QC feedback" ON qc_feedback FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Admins can view all QC feedback" ON qc_feedback FOR SELECT USING (is_admin());

-- Wishlist policies
CREATE POLICY "Users can view own wishlist" ON wishlist_items FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can manage own wishlist" ON wishlist_items FOR ALL USING (auth.uid() = user_id);

-- Notifications policies
CREATE POLICY "Users can view own notifications" ON notifications FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can update own notifications" ON notifications FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "System can insert notifications" ON notifications FOR INSERT WITH CHECK (true);
CREATE POLICY "Admins can view all notifications" ON notifications FOR SELECT USING (is_admin());

-- =====================================================
-- REALTIME
-- =====================================================

ALTER PUBLICATION supabase_realtime ADD TABLE products;
ALTER PUBLICATION supabase_realtime ADD TABLE product_variants;
ALTER PUBLICATION supabase_realtime ADD TABLE orders;
ALTER PUBLICATION supabase_realtime ADD TABLE notifications;

-- =====================================================
-- COMPLETE!
-- =====================================================
