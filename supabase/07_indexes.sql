-- STEP 7: INDEXES
-- Run after step 6

CREATE INDEX IF NOT EXISTS idx_companies_approval ON companies(approval_status);
CREATE INDEX IF NOT EXISTS idx_profiles_role ON profiles(role);
-- CREATE INDEX IF NOT EXISTS idx_profiles_company ON profiles(company_id); -- Commented out - column may not exist
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
CREATE INDEX IF NOT EXISTS idx_carts_user ON carts(user_id);
CREATE INDEX IF NOT EXISTS idx_cart_items_cart ON cart_items(cart_id);
CREATE INDEX IF NOT EXISTS idx_discounts_code ON discounts(code);
CREATE INDEX IF NOT EXISTS idx_discount_products_discount ON discount_products(discount_id);
CREATE INDEX IF NOT EXISTS idx_favourites_user ON favourites(user_id);
CREATE INDEX IF NOT EXISTS idx_sample_requests_user ON sample_requests(user_id);
CREATE INDEX IF NOT EXISTS idx_sample_requests_status ON sample_requests(status);
CREATE INDEX IF NOT EXISTS idx_orders_user ON orders(user_id);
-- CREATE INDEX IF NOT EXISTS idx_orders_company ON orders(company_id); -- Commented out - column may not exist
CREATE INDEX IF NOT EXISTS idx_orders_number ON orders(order_number);
CREATE INDEX IF NOT EXISTS idx_order_items_order ON order_items(order_id);
