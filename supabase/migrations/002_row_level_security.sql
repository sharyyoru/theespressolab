-- =====================================================
-- THE ESPRESSO LAB - ROW LEVEL SECURITY (RLS) POLICIES
-- =====================================================
-- Security policies for role-based access control
-- Roles: customer, wholesale, admin
-- =====================================================

-- =====================================================
-- 1. ENABLE RLS ON ALL TABLES
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

-- =====================================================
-- 2. HELPER FUNCTIONS
-- =====================================================

-- Get current user's role
CREATE OR REPLACE FUNCTION get_user_role()
RETURNS user_role AS $$
    SELECT role FROM profiles WHERE id = auth.uid();
$$ LANGUAGE sql SECURITY DEFINER;

-- Check if user is admin
CREATE OR REPLACE FUNCTION is_admin()
RETURNS BOOLEAN AS $$
    SELECT EXISTS (
        SELECT 1 FROM profiles 
        WHERE id = auth.uid() AND role = 'admin'
    );
$$ LANGUAGE sql SECURITY DEFINER;

-- Check if user is wholesale (approved)
CREATE OR REPLACE FUNCTION is_approved_wholesale()
RETURNS BOOLEAN AS $$
    SELECT EXISTS (
        SELECT 1 FROM profiles 
        WHERE id = auth.uid() 
        AND role = 'wholesale' 
        AND approval_status = 'approved'
    );
$$ LANGUAGE sql SECURITY DEFINER;

-- =====================================================
-- 3. PROFILES POLICIES
-- =====================================================

-- Users can view their own profile
CREATE POLICY "Users can view own profile"
    ON profiles FOR SELECT
    USING (auth.uid() = id);

-- Admins can view all profiles
CREATE POLICY "Admins can view all profiles"
    ON profiles FOR SELECT
    USING (is_admin());

-- Users can update their own profile (except role and approval_status)
CREATE POLICY "Users can update own profile"
    ON profiles FOR UPDATE
    USING (auth.uid() = id)
    WITH CHECK (
        auth.uid() = id 
        AND role = (SELECT role FROM profiles WHERE id = auth.uid())
        AND approval_status = (SELECT approval_status FROM profiles WHERE id = auth.uid())
    );

-- Admins can update any profile
CREATE POLICY "Admins can update any profile"
    ON profiles FOR UPDATE
    USING (is_admin());

-- New users can insert their own profile
CREATE POLICY "Users can insert own profile"
    ON profiles FOR INSERT
    WITH CHECK (auth.uid() = id);

-- =====================================================
-- 4. CATEGORIES POLICIES
-- =====================================================

-- Everyone can view active categories
CREATE POLICY "Anyone can view active categories"
    ON categories FOR SELECT
    USING (is_active = true OR is_admin());

-- Only admins can manage categories
CREATE POLICY "Admins can manage categories"
    ON categories FOR ALL
    USING (is_admin());

-- =====================================================
-- 5. PRODUCTS & VARIANTS POLICIES
-- =====================================================

-- Everyone can view active products
CREATE POLICY "Anyone can view active products"
    ON products FOR SELECT
    USING (
        is_active = true 
        OR is_admin()
    );

-- Wholesale users can view wholesale-only products if approved
CREATE POLICY "Wholesale can view wholesale products"
    ON products FOR SELECT
    USING (
        (is_wholesale_only = false)
        OR (is_wholesale_only = true AND is_approved_wholesale())
        OR is_admin()
    );

-- Only admins can manage products
CREATE POLICY "Admins can manage products"
    ON products FOR ALL
    USING (is_admin());

-- Everyone can view active variants
CREATE POLICY "Anyone can view active variants"
    ON product_variants FOR SELECT
    USING (is_active = true OR is_admin());

-- Only admins can manage variants
CREATE POLICY "Admins can manage variants"
    ON product_variants FOR ALL
    USING (is_admin());

-- =====================================================
-- 6. INVENTORY TRANSACTIONS POLICIES
-- =====================================================

-- Only admins can view inventory transactions
CREATE POLICY "Admins can view inventory transactions"
    ON inventory_transactions FOR SELECT
    USING (is_admin());

-- System can insert inventory transactions (via triggers)
CREATE POLICY "System can insert inventory transactions"
    ON inventory_transactions FOR INSERT
    WITH CHECK (true);

-- =====================================================
-- 7. COURSES POLICIES
-- =====================================================

-- Everyone can view active courses
CREATE POLICY "Anyone can view active courses"
    ON courses FOR SELECT
    USING (is_active = true OR is_admin());

-- Only admins can manage courses
CREATE POLICY "Admins can manage courses"
    ON courses FOR ALL
    USING (is_admin());

-- Everyone can view active schedules with available slots
CREATE POLICY "Anyone can view available schedules"
    ON course_schedules FOR SELECT
    USING (
        (is_active = true AND available_slots > 0)
        OR is_admin()
    );

-- Only admins can manage schedules
CREATE POLICY "Admins can manage schedules"
    ON course_schedules FOR ALL
    USING (is_admin());

-- =====================================================
-- 8. COURSE BOOKINGS POLICIES
-- =====================================================

-- Users can view their own bookings
CREATE POLICY "Users can view own bookings"
    ON course_bookings FOR SELECT
    USING (auth.uid() = user_id OR is_admin());

-- Authenticated users can create bookings
CREATE POLICY "Users can create bookings"
    ON course_bookings FOR INSERT
    WITH CHECK (auth.uid() = user_id);

-- Users can update their own pending bookings (cancel)
CREATE POLICY "Users can update own bookings"
    ON course_bookings FOR UPDATE
    USING (auth.uid() = user_id AND status = 'pending')
    WITH CHECK (auth.uid() = user_id);

-- Admins can manage all bookings
CREATE POLICY "Admins can manage all bookings"
    ON course_bookings FOR ALL
    USING (is_admin());

-- =====================================================
-- 9. ORDERS POLICIES
-- =====================================================

-- Users can view their own orders
CREATE POLICY "Users can view own orders"
    ON orders FOR SELECT
    USING (auth.uid() = user_id OR is_admin());

-- Authenticated users can create orders
CREATE POLICY "Users can create orders"
    ON orders FOR INSERT
    WITH CHECK (auth.uid() = user_id);

-- Users can update their own pending orders (cancel, upload receipt)
CREATE POLICY "Users can update own pending orders"
    ON orders FOR UPDATE
    USING (
        auth.uid() = user_id 
        AND status IN ('pending_payment', 'payment_received')
    )
    WITH CHECK (auth.uid() = user_id);

-- Admins can manage all orders
CREATE POLICY "Admins can manage all orders"
    ON orders FOR ALL
    USING (is_admin());

-- =====================================================
-- 10. ORDER ITEMS POLICIES
-- =====================================================

-- Users can view items from their own orders
CREATE POLICY "Users can view own order items"
    ON order_items FOR SELECT
    USING (
        EXISTS (
            SELECT 1 FROM orders 
            WHERE orders.id = order_items.order_id 
            AND orders.user_id = auth.uid()
        )
        OR is_admin()
    );

-- Users can insert items to their own orders
CREATE POLICY "Users can insert own order items"
    ON order_items FOR INSERT
    WITH CHECK (
        EXISTS (
            SELECT 1 FROM orders 
            WHERE orders.id = order_items.order_id 
            AND orders.user_id = auth.uid()
        )
    );

-- Admins can manage all order items
CREATE POLICY "Admins can manage all order items"
    ON order_items FOR ALL
    USING (is_admin());

-- =====================================================
-- 11. QC APPOINTMENTS POLICIES
-- =====================================================

-- Users can view their own QC appointments
CREATE POLICY "Users can view own QC appointments"
    ON qc_appointments FOR SELECT
    USING (auth.uid() = user_id OR is_admin());

-- Approved wholesale users can create QC appointments for their orders
CREATE POLICY "Wholesale can create QC appointments"
    ON qc_appointments FOR INSERT
    WITH CHECK (
        auth.uid() = user_id
        AND is_approved_wholesale()
        AND EXISTS (
            SELECT 1 FROM orders 
            WHERE orders.id = qc_appointments.order_id 
            AND orders.user_id = auth.uid()
        )
    );

-- Users can update their own requested appointments (add notes)
CREATE POLICY "Users can update own appointments"
    ON qc_appointments FOR UPDATE
    USING (auth.uid() = user_id AND status = 'requested')
    WITH CHECK (auth.uid() = user_id);

-- Admins can manage all QC appointments
CREATE POLICY "Admins can manage all QC appointments"
    ON qc_appointments FOR ALL
    USING (is_admin());

-- =====================================================
-- 12. QC REPORTS POLICIES
-- =====================================================

-- Users can view reports for their orders
CREATE POLICY "Users can view own QC reports"
    ON qc_reports FOR SELECT
    USING (
        EXISTS (
            SELECT 1 FROM orders 
            WHERE orders.id = qc_reports.order_id 
            AND orders.user_id = auth.uid()
        )
        OR is_admin()
    );

-- Only admins can create and manage QC reports
CREATE POLICY "Admins can manage QC reports"
    ON qc_reports FOR ALL
    USING (is_admin());

-- =====================================================
-- 13. QC ANSWERS POLICIES
-- =====================================================

-- Users can view answers for their QC reports
CREATE POLICY "Users can view own QC answers"
    ON qc_answers FOR SELECT
    USING (
        EXISTS (
            SELECT 1 FROM qc_reports 
            JOIN orders ON orders.id = qc_reports.order_id
            WHERE qc_reports.id = qc_answers.report_id 
            AND orders.user_id = auth.uid()
        )
        OR is_admin()
    );

-- Only admins can create and manage QC answers
CREATE POLICY "Admins can manage QC answers"
    ON qc_answers FOR ALL
    USING (is_admin());

-- =====================================================
-- 14. QC FEEDBACK POLICIES
-- =====================================================

-- Users can view their own feedback
CREATE POLICY "Users can view own QC feedback"
    ON qc_feedback FOR SELECT
    USING (auth.uid() = user_id OR is_admin());

-- Users can create feedback for their own QC reports
CREATE POLICY "Users can create QC feedback"
    ON qc_feedback FOR INSERT
    WITH CHECK (
        auth.uid() = user_id
        AND EXISTS (
            SELECT 1 FROM qc_reports 
            JOIN orders ON orders.id = qc_reports.order_id
            WHERE qc_reports.id = qc_feedback.report_id 
            AND orders.user_id = auth.uid()
        )
    );

-- Admins can view all feedback
CREATE POLICY "Admins can view all QC feedback"
    ON qc_feedback FOR SELECT
    USING (is_admin());

-- =====================================================
-- 15. WISHLIST POLICIES
-- =====================================================

-- Users can view their own wishlist
CREATE POLICY "Users can view own wishlist"
    ON wishlist_items FOR SELECT
    USING (auth.uid() = user_id);

-- Users can manage their own wishlist
CREATE POLICY "Users can manage own wishlist"
    ON wishlist_items FOR ALL
    USING (auth.uid() = user_id)
    WITH CHECK (auth.uid() = user_id);

-- =====================================================
-- 16. NOTIFICATIONS POLICIES
-- =====================================================

-- Users can view their own notifications
CREATE POLICY "Users can view own notifications"
    ON notifications FOR SELECT
    USING (auth.uid() = user_id);

-- Users can update their own notifications (mark as read)
CREATE POLICY "Users can update own notifications"
    ON notifications FOR UPDATE
    USING (auth.uid() = user_id)
    WITH CHECK (auth.uid() = user_id);

-- System can insert notifications
CREATE POLICY "System can insert notifications"
    ON notifications FOR INSERT
    WITH CHECK (true);

-- Admins can view all notifications
CREATE POLICY "Admins can view all notifications"
    ON notifications FOR SELECT
    USING (is_admin());

-- =====================================================
-- 17. STORAGE BUCKET POLICIES
-- =====================================================

-- Note: These are configured in Supabase Dashboard under Storage
-- 
-- qc-images bucket:
--   - Admins: Full access
--   - Users: Read access to their own order's QC images
--
-- bank-receipts bucket:
--   - Admins: Full access
--   - Users: Upload and read their own receipts
--
-- product-images bucket:
--   - Everyone: Read access
--   - Admins: Full access
--
-- documents bucket:
--   - Everyone: Read access (roasting PDFs, etc.)
--   - Admins: Full access

-- =====================================================
-- 18. REALTIME PUBLICATION
-- =====================================================

-- Enable realtime for inventory updates
ALTER PUBLICATION supabase_realtime ADD TABLE products;
ALTER PUBLICATION supabase_realtime ADD TABLE product_variants;
ALTER PUBLICATION supabase_realtime ADD TABLE orders;
ALTER PUBLICATION supabase_realtime ADD TABLE notifications;

-- =====================================================
-- END OF RLS POLICIES
-- =====================================================
