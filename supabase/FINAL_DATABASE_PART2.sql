-- =====================================================
-- PART 2: INDEXES, TRIGGERS, RLS POLICIES
-- Run after FINAL_DATABASE.sql
-- =====================================================

-- INDEXES
CREATE INDEX idx_profiles_role ON profiles(role);
CREATE INDEX idx_profiles_approval_status ON profiles(approval_status);
CREATE INDEX idx_categories_active ON categories(is_active);
CREATE INDEX idx_categories_slug ON categories(slug);
CREATE INDEX idx_taste_profiles_active ON taste_profiles(is_active);
CREATE INDEX idx_roast_profiles_active ON roast_profiles(is_active);
CREATE INDEX idx_products_category ON products(category_id);
CREATE INDEX idx_products_sku ON products(sku);
CREATE INDEX idx_products_active ON products(is_active);
CREATE INDEX idx_products_stock ON products(stock_quantity);
CREATE INDEX idx_products_collections ON products USING GIN(collections);
CREATE INDEX idx_product_taste_profiles_product ON product_taste_profiles(product_id);
CREATE INDEX idx_product_taste_profiles_taste ON product_taste_profiles(taste_profile_id);
CREATE INDEX idx_product_roast_profiles_product ON product_roast_profiles(product_id);
CREATE INDEX idx_product_roast_profiles_roast ON product_roast_profiles(roast_profile_id);
CREATE INDEX idx_product_graphs_product ON product_graphs(product_id);
CREATE INDEX idx_orders_user ON orders(user_id);
CREATE INDEX idx_orders_status ON orders(status);
CREATE INDEX idx_orders_number ON orders(order_number);
CREATE INDEX idx_orders_created ON orders(created_at DESC);
CREATE INDEX idx_order_items_order ON order_items(order_id);
CREATE INDEX idx_qc_appointments_order ON qc_appointments(order_id);
CREATE INDEX idx_qc_appointments_user ON qc_appointments(user_id);
CREATE INDEX idx_course_bookings_user ON course_bookings(user_id);
CREATE INDEX idx_wishlist_user ON wishlist_items(user_id);
CREATE INDEX idx_notifications_user ON notifications(user_id);

-- TRIGGERS
CREATE OR REPLACE FUNCTION update_updated_at_column() RETURNS TRIGGER AS $$
BEGIN NEW.updated_at = NOW(); RETURN NEW; END; $$ LANGUAGE plpgsql;

CREATE TRIGGER update_profiles_updated_at BEFORE UPDATE ON profiles FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_categories_updated_at BEFORE UPDATE ON categories FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_taste_profiles_updated_at BEFORE UPDATE ON taste_profiles FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_roast_profiles_updated_at BEFORE UPDATE ON roast_profiles FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_products_updated_at BEFORE UPDATE ON products FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_product_graphs_updated_at BEFORE UPDATE ON product_graphs FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_orders_updated_at BEFORE UPDATE ON orders FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE OR REPLACE FUNCTION generate_order_number() RETURNS TEXT AS $$
DECLARE new_number TEXT; counter INTEGER;
BEGIN SELECT COUNT(*) + 1 INTO counter FROM orders;
new_number := 'TEL-' || TO_CHAR(NOW(), 'YYYYMMDD') || '-' || LPAD(counter::TEXT, 4, '0');
RETURN new_number; END; $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION set_order_number() RETURNS TRIGGER AS $$
BEGIN IF NEW.order_number IS NULL THEN NEW.order_number := generate_order_number(); END IF; RETURN NEW; END; $$ LANGUAGE plpgsql;
CREATE TRIGGER set_order_number_trigger BEFORE INSERT ON orders FOR EACH ROW EXECUTE FUNCTION set_order_number();

CREATE OR REPLACE FUNCTION decrement_inventory_on_order() RETURNS TRIGGER AS $$
BEGIN IF NEW.status = 'payment_received' AND OLD.status = 'pending_payment' THEN
UPDATE products p SET stock_quantity = stock_quantity - oi.quantity FROM order_items oi WHERE oi.order_id = NEW.id AND oi.product_id = p.id AND oi.variant_id IS NULL;
UPDATE product_variants pv SET stock_quantity = stock_quantity - oi.quantity FROM order_items oi WHERE oi.order_id = NEW.id AND oi.variant_id = pv.id;
INSERT INTO inventory_transactions (product_id, variant_id, quantity_change, transaction_type, reference_id)
SELECT oi.product_id, oi.variant_id, -oi.quantity, 'sale', NEW.id FROM order_items oi WHERE oi.order_id = NEW.id;
END IF; RETURN NEW; END; $$ LANGUAGE plpgsql;
CREATE TRIGGER decrement_inventory_trigger AFTER UPDATE ON orders FOR EACH ROW EXECUTE FUNCTION decrement_inventory_on_order();

-- RLS
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE taste_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE roast_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE products ENABLE ROW LEVEL SECURITY;
ALTER TABLE product_variants ENABLE ROW LEVEL SECURITY;
ALTER TABLE product_taste_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE product_roast_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE product_graphs ENABLE ROW LEVEL SECURITY;
ALTER TABLE inventory_transactions ENABLE ROW LEVEL SECURITY;
ALTER TABLE courses ENABLE ROW LEVEL SECURITY;
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE order_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE qc_appointments ENABLE ROW LEVEL SECURITY;
ALTER TABLE wishlist_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE notifications ENABLE ROW LEVEL SECURITY;

CREATE OR REPLACE FUNCTION is_admin() RETURNS BOOLEAN AS $$
SELECT EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'admin'); $$ LANGUAGE sql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION is_approved_wholesale() RETURNS BOOLEAN AS $$
SELECT EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'wholesale' AND approval_status = 'approved'); $$ LANGUAGE sql SECURITY DEFINER;

CREATE POLICY "Users can view own profile" ON profiles FOR SELECT USING (auth.uid() = id);
CREATE POLICY "Admins can view all profiles" ON profiles FOR SELECT USING (is_admin());
CREATE POLICY "Users can update own profile" ON profiles FOR UPDATE USING (auth.uid() = id);
CREATE POLICY "Admins can update any profile" ON profiles FOR UPDATE USING (is_admin());
CREATE POLICY "Users can insert own profile" ON profiles FOR INSERT WITH CHECK (auth.uid() = id);

CREATE POLICY "Anyone can view active categories" ON categories FOR SELECT USING (is_active = true OR is_admin());
CREATE POLICY "Admins can manage categories" ON categories FOR ALL USING (is_admin());

CREATE POLICY "Anyone can view active taste profiles" ON taste_profiles FOR SELECT USING (is_active = true OR is_admin());
CREATE POLICY "Admins can manage taste profiles" ON taste_profiles FOR ALL USING (is_admin());

CREATE POLICY "Anyone can view active roast profiles" ON roast_profiles FOR SELECT USING (is_active = true OR is_admin());
CREATE POLICY "Admins can manage roast profiles" ON roast_profiles FOR ALL USING (is_admin());

CREATE POLICY "Anyone can view active products" ON products FOR SELECT USING (is_active = true OR is_admin());
CREATE POLICY "Admins can manage products" ON products FOR ALL USING (is_admin());

CREATE POLICY "Anyone can view active variants" ON product_variants FOR SELECT USING (is_active = true OR is_admin());
CREATE POLICY "Admins can manage variants" ON product_variants FOR ALL USING (is_admin());

CREATE POLICY "Anyone can view product taste profiles" ON product_taste_profiles FOR SELECT USING (true);
CREATE POLICY "Admins can manage product taste profiles" ON product_taste_profiles FOR ALL USING (is_admin());

CREATE POLICY "Anyone can view product roast profiles" ON product_roast_profiles FOR SELECT USING (true);
CREATE POLICY "Admins can manage product roast profiles" ON product_roast_profiles FOR ALL USING (is_admin());

CREATE POLICY "Anyone can view product graphs" ON product_graphs FOR SELECT USING (true);
CREATE POLICY "Admins can manage product graphs" ON product_graphs FOR ALL USING (is_admin());

CREATE POLICY "Admins can view inventory transactions" ON inventory_transactions FOR SELECT USING (is_admin());
CREATE POLICY "System can insert inventory transactions" ON inventory_transactions FOR INSERT WITH CHECK (true);

CREATE POLICY "Anyone can view active courses" ON courses FOR SELECT USING (is_active = true OR is_admin());
CREATE POLICY "Admins can manage courses" ON courses FOR ALL USING (is_admin());

CREATE POLICY "Users can view own orders" ON orders FOR SELECT USING (auth.uid() = user_id OR is_admin());
CREATE POLICY "Users can create orders" ON orders FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Admins can manage all orders" ON orders FOR ALL USING (is_admin());

CREATE POLICY "Users can view own order items" ON order_items FOR SELECT USING (EXISTS (SELECT 1 FROM orders WHERE orders.id = order_items.order_id AND orders.user_id = auth.uid()) OR is_admin());
CREATE POLICY "Users can insert own order items" ON order_items FOR INSERT WITH CHECK (EXISTS (SELECT 1 FROM orders WHERE orders.id = order_items.order_id AND orders.user_id = auth.uid()));
CREATE POLICY "Admins can manage all order items" ON order_items FOR ALL USING (is_admin());

CREATE POLICY "Users can view own QC appointments" ON qc_appointments FOR SELECT USING (auth.uid() = user_id OR is_admin());
CREATE POLICY "Wholesale can create QC appointments" ON qc_appointments FOR INSERT WITH CHECK (auth.uid() = user_id AND is_approved_wholesale());
CREATE POLICY "Admins can manage all QC appointments" ON qc_appointments FOR ALL USING (is_admin());

CREATE POLICY "Users can view own wishlist" ON wishlist_items FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can manage own wishlist" ON wishlist_items FOR ALL USING (auth.uid() = user_id);

CREATE POLICY "Users can view own notifications" ON notifications FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can update own notifications" ON notifications FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "System can insert notifications" ON notifications FOR INSERT WITH CHECK (true);

-- REALTIME
ALTER PUBLICATION supabase_realtime ADD TABLE products;
ALTER PUBLICATION supabase_realtime ADD TABLE orders;
ALTER PUBLICATION supabase_realtime ADD TABLE notifications;
