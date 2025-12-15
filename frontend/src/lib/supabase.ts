import { createClient } from '@supabase/supabase-js'

const supabaseUrl = process.env.REACT_APP_SUPABASE_URL || ''
const supabaseAnonKey = process.env.REACT_APP_SUPABASE_ANON_KEY || ''

export const supabase = createClient(supabaseUrl, supabaseAnonKey)

export type Profile = {
  id: string
  email: string
  full_name?: string
  phone?: string
  role: 'customer' | 'wholesale' | 'admin'
  approval_status: 'pending' | 'approved' | 'rejected'
  company_name?: string
  created_at: string
  updated_at: string
}

export type Product = {
  id: string
  sanity_id: string
  sku: string
  category_id?: string
  price: number
  stock_quantity: number
  low_stock_threshold: number
  is_active: boolean
  is_wholesale_only: boolean
  collections?: string[]
  created_at: string
  updated_at: string
}

export type Order = {
  id: string
  order_number: string
  user_id?: string
  status: string
  payment_method: 'stripe' | 'bank_transfer'
  payment_status: string
  subtotal: number
  tax: number
  shipping_fee: number
  total_amount: number
  shipping_full_name: string
  shipping_phone: string
  shipping_address_line1: string
  shipping_city: string
  shipping_country: string
  created_at: string
  updated_at: string
}
