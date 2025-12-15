-- STEP 1: EXTENSIONS AND ENUMS
-- Run this first

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

DO $$ BEGIN CREATE TYPE user_role AS ENUM ('customer','wholesale','admin'); EXCEPTION WHEN duplicate_object THEN null; END $$;
DO $$ BEGIN CREATE TYPE approval_status AS ENUM ('pending','approved','rejected'); EXCEPTION WHEN duplicate_object THEN null; END $$;
DO $$ BEGIN CREATE TYPE order_status AS ENUM ('pending_payment','payment_received','processing','qc_scheduled','qc_completed','shipped','delivered','cancelled','refunded'); EXCEPTION WHEN duplicate_object THEN null; END $$;
DO $$ BEGIN CREATE TYPE payment_method AS ENUM ('stripe','bank_transfer'); EXCEPTION WHEN duplicate_object THEN null; END $$;
DO $$ BEGIN CREATE TYPE booking_status AS ENUM ('pending','confirmed','cancelled','completed','rescheduled'); EXCEPTION WHEN duplicate_object THEN null; END $$;
DO $$ BEGIN CREATE TYPE qc_appointment_status AS ENUM ('requested','scheduled','in_progress','completed','cancelled'); EXCEPTION WHEN duplicate_object THEN null; END $$;
DO $$ BEGIN CREATE TYPE notification_type AS ENUM ('order_placed','order_approved','order_shipped','qc_scheduled','qc_completed','course_booked','wholesale_approved','wholesale_rejected','sample_approved','sample_rejected'); EXCEPTION WHEN duplicate_object THEN null; END $$;
DO $$ BEGIN CREATE TYPE discount_type AS ENUM ('percentage','fixed_amount','free_shipping'); EXCEPTION WHEN duplicate_object THEN null; END $$;
DO $$ BEGIN CREATE TYPE sample_request_status AS ENUM ('pending','approved','rejected','shipped','delivered'); EXCEPTION WHEN duplicate_object THEN null; END $$;
