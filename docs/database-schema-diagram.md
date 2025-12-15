# The Espresso Lab - Database Schema Diagram

## Entity Relationship Diagram (ERD)

```mermaid
erDiagram
    %% =====================================================
    %% USER MANAGEMENT
    %% =====================================================
    
    profiles {
        uuid id PK
        text email UK
        text full_name
        text phone
        user_role role
        approval_status approval_status
        text company_name
        text business_license
        timestamptz created_at
        timestamptz updated_at
    }

    %% =====================================================
    %% INVENTORY & PRODUCTS
    %% =====================================================
    
    categories {
        uuid id PK
        text sanity_id UK
        text slug UK
        boolean is_active
        integer sort_order
        timestamptz created_at
        timestamptz updated_at
    }

    products {
        uuid id PK
        text sanity_id UK
        text sku UK
        uuid category_id FK
        decimal price
        integer stock_quantity
        integer low_stock_threshold
        boolean is_active
        boolean is_wholesale_only
        collection_type[] collections
        timestamptz created_at
        timestamptz updated_at
    }

    product_variants {
        uuid id PK
        uuid product_id FK
        text sanity_id
        text sku UK
        decimal price_adjustment
        integer stock_quantity
        boolean is_active
        timestamptz created_at
        timestamptz updated_at
    }

    inventory_transactions {
        uuid id PK
        uuid product_id FK
        uuid variant_id FK
        integer quantity_change
        text transaction_type
        uuid reference_id
        text notes
        uuid created_by FK
        timestamptz created_at
    }

    %% =====================================================
    %% COURSES
    %% =====================================================
    
    courses {
        uuid id PK
        text sanity_id UK
        decimal price
        integer duration_minutes
        integer max_participants
        boolean is_active
        timestamptz created_at
        timestamptz updated_at
    }

    course_schedules {
        uuid id PK
        uuid course_id FK
        timestamptz start_time
        timestamptz end_time
        integer available_slots
        boolean is_active
        timestamptz created_at
        timestamptz updated_at
    }

    course_bookings {
        uuid id PK
        uuid course_id FK
        uuid schedule_id FK
        uuid user_id FK
        integer participants_count
        booking_status status
        text payment_status
        decimal total_amount
        text notes
        text admin_notes
        timestamptz created_at
        timestamptz updated_at
    }

    %% =====================================================
    %% ORDERS & PAYMENTS
    %% =====================================================
    
    orders {
        uuid id PK
        text order_number UK
        uuid user_id FK
        order_status status
        payment_method payment_method
        text payment_status
        text stripe_payment_intent_id
        text bank_transfer_receipt_url
        decimal subtotal
        decimal tax
        decimal shipping_fee
        decimal total_amount
        text shipping_full_name
        text shipping_phone
        text shipping_address_line1
        text shipping_address_line2
        text shipping_city
        text shipping_state
        text shipping_postal_code
        text shipping_country
        text tracking_number
        timestamptz shipped_at
        timestamptz delivered_at
        text notes
        text admin_notes
        timestamptz created_at
        timestamptz updated_at
    }

    order_items {
        uuid id PK
        uuid order_id FK
        uuid product_id FK
        uuid variant_id FK
        text product_name
        text product_sku
        jsonb variant_details
        integer quantity
        decimal unit_price
        decimal total_price
        timestamptz created_at
    }

    %% =====================================================
    %% QUALITY CONTROL
    %% =====================================================
    
    qc_appointments {
        uuid id PK
        uuid order_id FK
        uuid user_id FK
        qc_appointment_status status
        timestamptz scheduled_date
        timestamptz completed_date
        text customer_notes
        text admin_notes
        timestamptz created_at
        timestamptz updated_at
    }

    qc_reports {
        uuid id PK
        uuid appointment_id FK
        uuid order_id FK
        uuid inspector_id FK
        integer overall_rating
        text overall_notes
        text[] images_urls
        boolean passed
        timestamptz completed_at
        timestamptz created_at
        timestamptz updated_at
    }

    qc_answers {
        uuid id PK
        uuid report_id FK
        text question_sanity_id
        text question_text
        text answer_value
        integer rating
        text notes
        timestamptz created_at
    }

    qc_feedback {
        uuid id PK
        uuid report_id FK
        uuid user_id FK
        integer rating
        text comments
        timestamptz created_at
    }

    %% =====================================================
    %% WISHLIST & NOTIFICATIONS
    %% =====================================================
    
    wishlist_items {
        uuid id PK
        uuid user_id FK
        uuid product_id FK
        uuid variant_id FK
        timestamptz created_at
    }

    notifications {
        uuid id PK
        uuid user_id FK
        notification_type type
        text title
        text message
        uuid reference_id
        boolean is_read
        boolean email_sent
        timestamptz created_at
    }

    %% =====================================================
    %% RELATIONSHIPS
    %% =====================================================
    
    %% Products & Categories
    categories ||--o{ products : "contains"
    products ||--o{ product_variants : "has variants"
    products ||--o{ inventory_transactions : "tracks"
    product_variants ||--o{ inventory_transactions : "tracks"
    profiles ||--o{ inventory_transactions : "created by"

    %% Orders
    profiles ||--o{ orders : "places"
    orders ||--o{ order_items : "contains"
    products ||--o{ order_items : "ordered in"
    product_variants ||--o{ order_items : "ordered as"

    %% Courses
    courses ||--o{ course_schedules : "has schedules"
    courses ||--o{ course_bookings : "booked for"
    course_schedules ||--o{ course_bookings : "booked at"
    profiles ||--o{ course_bookings : "books"

    %% Quality Control
    orders ||--o{ qc_appointments : "requires"
    profiles ||--o{ qc_appointments : "requests"
    qc_appointments ||--o{ qc_reports : "generates"
    orders ||--o{ qc_reports : "inspected in"
    profiles ||--o{ qc_reports : "inspected by"
    qc_reports ||--o{ qc_answers : "contains"
    qc_reports ||--o{ qc_feedback : "receives"
    profiles ||--o{ qc_feedback : "provides"

    %% Wishlist
    profiles ||--o{ wishlist_items : "saves"
    products ||--o{ wishlist_items : "saved in"
    product_variants ||--o{ wishlist_items : "saved as"

    %% Notifications
    profiles ||--o{ notifications : "receives"
```

## Data Flow Diagrams

### 1. Order Processing Flow

```mermaid
flowchart TD
    A[Customer Places Order] --> B{Payment Method?}
    B -->|Stripe| C[Stripe Payment]
    B -->|Bank Transfer| D[Upload Receipt]
    
    C --> E[Payment Received]
    D --> F[Admin Approval]
    F --> E
    
    E --> G[Inventory Decremented]
    G --> H{Wholesale Order?}
    
    H -->|Yes| I[QC Appointment Scheduled]
    H -->|No| J[Order Processing]
    
    I --> K[QC Inspection]
    K --> L[QC Report Generated]
    L --> M[Customer Notified]
    M --> N[Customer Feedback]
    N --> J
    
    J --> O[Order Shipped]
    O --> P[Tracking Updated]
    P --> Q[Order Delivered]
    
    style E fill:#90EE90
    style G fill:#FFD700
    style L fill:#87CEEB
    style Q fill:#98FB98
```

### 2. Quality Control Flow

```mermaid
flowchart TD
    A[Wholesale Customer] --> B[Places Order]
    B --> C[Payment Confirmed]
    C --> D[Customer Requests QC]
    
    D --> E[QC Appointment Created]
    E --> F[Admin Schedules Date/Time]
    F --> G[Customer Notified]
    
    G --> H[QC Inspection Day]
    H --> I[Admin Opens QC Form]
    I --> J[Loads Questions from Sanity]
    
    J --> K[Admin Answers Questions]
    K --> L[Admin Uploads Images]
    L --> M[Admin Submits Report]
    
    M --> N[QC Report Saved]
    N --> O[Email Sent to Customer]
    O --> P[Customer Views Report]
    
    P --> Q[Customer Provides Feedback]
    Q --> R{Passed?}
    
    R -->|Yes| S[Order Ships]
    R -->|No| T[Issue Resolution]
    T --> U[Re-inspection or Refund]
    
    style D fill:#FFE4B5
    style M fill:#87CEEB
    style O fill:#90EE90
    style S fill:#98FB98
```

### 3. Inventory Real-Time Update Flow

```mermaid
flowchart LR
    A[React Frontend] --> B[Add to Cart]
    B --> C{Check Stock}
    
    C -->|Query| D[(Supabase Products)]
    D -->|Stock Available| E[Enable Checkout]
    D -->|Out of Stock| F[Disable Button]
    
    E --> G[Order Placed]
    G --> H[Payment Confirmed]
    H --> I[Trigger: decrement_inventory]
    
    I --> J[Update stock_quantity]
    J --> K[Log inventory_transactions]
    K --> L[Realtime Broadcast]
    
    L --> M[Admin Dashboard]
    L --> N[Product Page]
    
    M --> O[Update Stock Display]
    N --> P[Update Add to Cart Button]
    
    style D fill:#4169E1
    style I fill:#FF6347
    style L fill:#FFD700
    style O fill:#90EE90
    style P fill:#90EE90
```

### 4. Hybrid Data Architecture (Sanity + Supabase)

```mermaid
flowchart TD
    subgraph Sanity CMS
        A[Product Content]
        B[Tasting Notes]
        C[Producer Story]
        D[Images/Videos]
        E[QC Question Templates]
        F[Blog Posts]
        G[Page Content]
    end
    
    subgraph Supabase Database
        H[Product SKU]
        I[Stock Quantity]
        J[Price]
        K[Orders]
        L[QC Reports]
        M[User Profiles]
    end
    
    subgraph React Frontend
        N[Product Page]
        O[Admin Portal]
        P[QC Dashboard]
    end
    
    A --> N
    B --> N
    C --> N
    D --> N
    
    H --> N
    I --> N
    J --> N
    
    E --> O
    E --> P
    
    K --> O
    L --> P
    M --> O
    
    N -->|Update Stock| I
    O -->|Create Order| K
    P -->|Submit Report| L
    
    style A fill:#F4A460
    style E fill:#F4A460
    style H fill:#4169E1
    style I fill:#4169E1
    style N fill:#90EE90
```

## Key Design Decisions

### 1. **Hybrid Data Model**
- **Sanity**: Rich content (descriptions, images, stories, QC templates)
- **Supabase**: Operational data (stock, prices, orders, real-time updates)
- **Sync Point**: `sanity_id` field links Supabase records to Sanity documents

### 2. **Real-Time Inventory**
- Triggers automatically decrement stock on payment confirmation
- Realtime subscriptions push updates to all connected clients
- Inventory transactions table provides complete audit trail

### 3. **Quality Control Integration**
- QC appointments linked directly to orders
- Question templates stored in Sanity for easy updates
- Answers stored in Supabase with snapshots for historical accuracy
- Images stored in Supabase Storage

### 4. **Wholesale vs Retail**
- Single unified system with role-based access
- `is_wholesale_only` flag on products
- `approval_status` on profiles gates wholesale access
- QC module only activated for wholesale orders

### 5. **Order Status Progression**
```
pending_payment → payment_received → processing → 
qc_scheduled (wholesale only) → qc_completed → 
shipped → delivered
```

### 6. **Security Layers**
- Row Level Security (RLS) policies (see separate file)
- Role-based access control (customer, wholesale, admin)
- Approval workflow for wholesale accounts
- Audit trails via inventory_transactions and timestamps

## Table Relationships Summary

| Parent Table | Child Table | Relationship Type | Key Field |
|--------------|-------------|-------------------|-----------|
| profiles | orders | One-to-Many | user_id |
| profiles | qc_appointments | One-to-Many | user_id |
| profiles | course_bookings | One-to-Many | user_id |
| orders | order_items | One-to-Many | order_id |
| orders | qc_appointments | One-to-Many | order_id |
| orders | qc_reports | One-to-Many | order_id |
| products | order_items | One-to-Many | product_id |
| products | product_variants | One-to-Many | product_id |
| products | inventory_transactions | One-to-Many | product_id |
| qc_appointments | qc_reports | One-to-Many | appointment_id |
| qc_reports | qc_answers | One-to-Many | report_id |
| qc_reports | qc_feedback | One-to-Many | report_id |
| courses | course_schedules | One-to-Many | course_id |
| course_schedules | course_bookings | One-to-Many | schedule_id |

## Storage Buckets (Supabase Storage)

```
espressolab-storage/
├── qc-images/              # QC inspection photos
│   └── {report_id}/
│       ├── image1.jpg
│       └── image2.jpg
├── bank-receipts/          # Bank transfer receipts
│   └── {order_id}/
│       └── receipt.pdf
├── product-images/         # Product photos (if not in Sanity)
└── documents/              # Roasting PDFs, certificates
    └── {product_id}/
        └── roasting-profile.pdf
```
