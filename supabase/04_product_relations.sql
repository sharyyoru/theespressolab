-- STEP 4: PRODUCT RELATIONS
-- Run after step 3

CREATE TABLE IF NOT EXISTS product_collections (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    product_id UUID REFERENCES products(id) ON DELETE CASCADE,
    collection_id UUID REFERENCES collections(id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(product_id, collection_id)
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

CREATE TABLE IF NOT EXISTS product_graph_1 (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    product_id UUID REFERENCES products(id) ON DELETE CASCADE,
    graph_name_en TEXT DEFAULT 'Acidity vs Body',
    graph_name_ar TEXT DEFAULT 'الحموضة مقابل القوام',
    value_x DECIMAL(5,2) NOT NULL,
    value_y DECIMAL(5,2) NOT NULL,
    label_x_en TEXT DEFAULT 'Acidity',
    label_x_ar TEXT DEFAULT 'الحموضة',
    label_y_en TEXT DEFAULT 'Body',
    label_y_ar TEXT DEFAULT 'القوام',
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(product_id)
);

CREATE TABLE IF NOT EXISTS product_graph_2 (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    product_id UUID REFERENCES products(id) ON DELETE CASCADE,
    graph_name_en TEXT DEFAULT 'Sweetness vs Bitterness',
    graph_name_ar TEXT DEFAULT 'الحلاوة مقابل المرارة',
    value_x DECIMAL(5,2) NOT NULL,
    value_y DECIMAL(5,2) NOT NULL,
    label_x_en TEXT DEFAULT 'Sweetness',
    label_x_ar TEXT DEFAULT 'الحلاوة',
    label_y_en TEXT DEFAULT 'Bitterness',
    label_y_ar TEXT DEFAULT 'المرارة',
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(product_id)
);

CREATE TABLE IF NOT EXISTS product_graph_3 (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    product_id UUID REFERENCES products(id) ON DELETE CASCADE,
    graph_name_en TEXT DEFAULT 'Aroma vs Aftertaste',
    graph_name_ar TEXT DEFAULT 'الرائحة مقابل الطعم المتبقي',
    value_x DECIMAL(5,2) NOT NULL,
    value_y DECIMAL(5,2) NOT NULL,
    label_x_en TEXT DEFAULT 'Aroma',
    label_x_ar TEXT DEFAULT 'الرائحة',
    label_y_en TEXT DEFAULT 'Aftertaste',
    label_y_ar TEXT DEFAULT 'الطعم المتبقي',
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
    price_adjustment DECIMAL(10,2) DEFAULT 0,
    stock_quantity INTEGER DEFAULT 0 NOT NULL,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS discount_products (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    discount_id UUID REFERENCES discounts(id) ON DELETE CASCADE,
    product_id UUID REFERENCES products(id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(discount_id, product_id)
);
