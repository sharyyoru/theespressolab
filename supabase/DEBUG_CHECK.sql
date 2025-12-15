-- RUN THIS TO DEBUG THE ISSUE

-- Check 1: Find ALL orders tables in all schemas
SELECT table_schema, table_name 
FROM information_schema.tables 
WHERE table_name = 'orders';

-- Check 2: List all columns in the orders table(s)
SELECT table_schema, table_name, column_name, data_type, ordinal_position
FROM information_schema.columns 
WHERE table_name = 'orders'
ORDER BY table_schema, ordinal_position;

-- Check 3: Check for existing indexes on orders
SELECT schemaname, tablename, indexname, indexdef
FROM pg_indexes
WHERE tablename = 'orders';

-- Check 4: Try to select company_id directly
SELECT company_id FROM orders LIMIT 0;
