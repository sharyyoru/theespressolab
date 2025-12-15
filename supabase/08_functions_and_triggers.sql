-- STEP 8: FUNCTIONS AND TRIGGERS
-- Run after step 7

CREATE OR REPLACE FUNCTION update_updated_at_column() RETURNS TRIGGER AS $$
BEGIN NEW.updated_at=NOW(); RETURN NEW; END; $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION generate_order_number() RETURNS TEXT AS $$
DECLARE n TEXT; c INTEGER;
BEGIN SELECT COUNT(*)+1 INTO c FROM orders;
n:='TEL-'||TO_CHAR(NOW(),'YYYYMMDD')||'-'||LPAD(c::TEXT,4,'0');
RETURN n; END; $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION generate_sample_request_number() RETURNS TEXT AS $$
DECLARE n TEXT; c INTEGER;
BEGIN SELECT COUNT(*)+1 INTO c FROM sample_requests;
n:='SMP-'||TO_CHAR(NOW(),'YYYYMMDD')||'-'||LPAD(c::TEXT,4,'0');
RETURN n; END; $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION set_order_number() RETURNS TRIGGER AS $$
BEGIN IF NEW.order_number IS NULL THEN NEW.order_number:=generate_order_number(); END IF;
RETURN NEW; END; $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION set_sample_request_number() RETURNS TRIGGER AS $$
BEGIN IF NEW.request_number IS NULL THEN NEW.request_number:=generate_sample_request_number(); END IF;
RETURN NEW; END; $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION decrement_inventory_on_order() RETURNS TRIGGER AS $$
BEGIN IF NEW.status='payment_received' AND OLD.status='pending_payment' THEN
UPDATE products p SET stock_quantity=stock_quantity-oi.quantity FROM order_items oi WHERE oi.order_id=NEW.id AND oi.product_id=p.id;
UPDATE product_variants pv SET stock_quantity=stock_quantity-oi.quantity FROM order_items oi WHERE oi.order_id=NEW.id AND oi.variant_id=pv.id;
INSERT INTO inventory_transactions(product_id,variant_id,quantity_change,transaction_type,reference_id)
SELECT oi.product_id,oi.variant_id,-oi.quantity,'sale',NEW.id FROM order_items oi WHERE oi.order_id=NEW.id;
END IF; RETURN NEW; END; $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION increment_discount_usage() RETURNS TRIGGER AS $$
BEGIN IF NEW.discount_id IS NOT NULL THEN
UPDATE discounts SET usage_count=usage_count+1 WHERE id=NEW.discount_id;
END IF; RETURN NEW; END; $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION is_admin() RETURNS BOOLEAN AS $$
SELECT EXISTS(SELECT 1 FROM profiles WHERE id=auth.uid() AND role='admin'); $$ LANGUAGE sql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION is_approved_wholesale() RETURNS BOOLEAN AS $$
SELECT EXISTS(SELECT 1 FROM profiles WHERE id=auth.uid() AND role='wholesale' AND approval_status='approved'); $$ LANGUAGE sql SECURITY DEFINER;

DROP TRIGGER IF EXISTS update_companies_updated_at ON companies;
CREATE TRIGGER update_companies_updated_at BEFORE UPDATE ON companies FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_profiles_updated_at ON profiles;
CREATE TRIGGER update_profiles_updated_at BEFORE UPDATE ON profiles FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_products_updated_at ON products;
CREATE TRIGGER update_products_updated_at BEFORE UPDATE ON products FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_carts_updated_at ON carts;
CREATE TRIGGER update_carts_updated_at BEFORE UPDATE ON carts FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_orders_updated_at ON orders;
CREATE TRIGGER update_orders_updated_at BEFORE UPDATE ON orders FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_sample_requests_updated_at ON sample_requests;
CREATE TRIGGER update_sample_requests_updated_at BEFORE UPDATE ON sample_requests FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS set_order_number_trigger ON orders;
CREATE TRIGGER set_order_number_trigger BEFORE INSERT ON orders FOR EACH ROW EXECUTE FUNCTION set_order_number();

DROP TRIGGER IF EXISTS set_sample_request_number_trigger ON sample_requests;
CREATE TRIGGER set_sample_request_number_trigger BEFORE INSERT ON sample_requests FOR EACH ROW EXECUTE FUNCTION set_sample_request_number();

DROP TRIGGER IF EXISTS decrement_inventory_trigger ON orders;
CREATE TRIGGER decrement_inventory_trigger AFTER UPDATE ON orders FOR EACH ROW EXECUTE FUNCTION decrement_inventory_on_order();

DROP TRIGGER IF EXISTS increment_discount_usage_trigger ON orders;
CREATE TRIGGER increment_discount_usage_trigger AFTER INSERT ON orders FOR EACH ROW EXECUTE FUNCTION increment_discount_usage();
