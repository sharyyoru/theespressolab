// =====================================================
// SUPABASE EDGE FUNCTION: Send Order Notification
// =====================================================
// Triggered when a new order is placed
// Sends email to admin and customer with invoice PDF
// =====================================================

import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

const RESEND_API_KEY = Deno.env.get('RESEND_API_KEY')
const SUPABASE_URL = Deno.env.get('SUPABASE_URL')
const SUPABASE_SERVICE_ROLE_KEY = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')
const ADMIN_EMAIL = Deno.env.get('ADMIN_EMAIL') || 'admin@espressolab.com'

interface OrderNotificationPayload {
  order_id: string
  type: 'order_placed' | 'payment_confirmed' | 'order_shipped'
}

serve(async (req) => {
  try {
    const { order_id, type }: OrderNotificationPayload = await req.json()

    // Initialize Supabase client
    const supabase = createClient(
      SUPABASE_URL!,
      SUPABASE_SERVICE_ROLE_KEY!
    )

    // Fetch order details with user info and items
    const { data: order, error: orderError } = await supabase
      .from('orders')
      .select(`
        *,
        profiles:user_id (
          email,
          full_name
        ),
        order_items (
          *,
          products (
            sanity_id
          )
        )
      `)
      .eq('id', order_id)
      .single()

    if (orderError || !order) {
      throw new Error(`Order not found: ${orderError?.message}`)
    }

    // Generate invoice HTML
    const invoiceHTML = generateInvoiceHTML(order)

    // Send email to customer
    await sendEmail({
      to: order.profiles.email,
      subject: `Order Confirmation - ${order.order_number}`,
      html: generateCustomerEmailHTML(order, type),
      attachments: [{
        filename: `invoice-${order.order_number}.pdf`,
        content: await generateInvoicePDF(invoiceHTML)
      }]
    })

    // Send email to admin
    await sendEmail({
      to: ADMIN_EMAIL,
      subject: `New Order Received - ${order.order_number}`,
      html: generateAdminEmailHTML(order)
    })

    // Create notification records
    await supabase.from('notifications').insert([
      {
        user_id: order.user_id,
        type: 'order_placed',
        title: 'Order Placed Successfully',
        message: `Your order ${order.order_number} has been placed successfully.`,
        reference_id: order.id,
        email_sent: true
      }
    ])

    return new Response(
      JSON.stringify({ success: true, order_number: order.order_number }),
      { headers: { 'Content-Type': 'application/json' } }
    )

  } catch (error) {
    console.error('Error sending order notification:', error)
    return new Response(
      JSON.stringify({ error: error.message }),
      { status: 500, headers: { 'Content-Type': 'application/json' } }
    )
  }
})

async function sendEmail({ to, subject, html, attachments = [] }: any) {
  const response = await fetch('https://api.resend.com/emails', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${RESEND_API_KEY}`
    },
    body: JSON.stringify({
      from: 'The Espresso Lab <orders@espressolab.com>',
      to,
      subject,
      html,
      attachments
    })
  })

  if (!response.ok) {
    throw new Error(`Failed to send email: ${await response.text()}`)
  }

  return response.json()
}

function generateInvoiceHTML(order: any): string {
  const itemsHTML = order.order_items.map((item: any) => `
    <tr>
      <td style="padding: 10px; border-bottom: 1px solid #eee;">${item.product_name}</td>
      <td style="padding: 10px; border-bottom: 1px solid #eee; text-align: center;">${item.quantity}</td>
      <td style="padding: 10px; border-bottom: 1px solid #eee; text-align: right;">$${item.unit_price.toFixed(2)}</td>
      <td style="padding: 10px; border-bottom: 1px solid #eee; text-align: right;">$${item.total_price.toFixed(2)}</td>
    </tr>
  `).join('')

  return `
    <!DOCTYPE html>
    <html>
    <head>
      <meta charset="utf-8">
      <title>Invoice - ${order.order_number}</title>
    </head>
    <body style="font-family: Arial, sans-serif; max-width: 800px; margin: 0 auto; padding: 20px;">
      <div style="text-align: center; margin-bottom: 30px;">
        <h1 style="color: #2c3e50;">THE ESPRESSO LAB</h1>
        <p style="color: #7f8c8d;">Premium Coffee & Equipment</p>
      </div>

      <div style="background: #f8f9fa; padding: 20px; border-radius: 8px; margin-bottom: 30px;">
        <h2 style="margin-top: 0;">Invoice</h2>
        <p><strong>Order Number:</strong> ${order.order_number}</p>
        <p><strong>Date:</strong> ${new Date(order.created_at).toLocaleDateString()}</p>
        <p><strong>Status:</strong> ${order.status}</p>
      </div>

      <div style="margin-bottom: 30px;">
        <h3>Shipping Address</h3>
        <p>
          ${order.shipping_full_name}<br>
          ${order.shipping_address_line1}<br>
          ${order.shipping_address_line2 ? order.shipping_address_line2 + '<br>' : ''}
          ${order.shipping_city}, ${order.shipping_state} ${order.shipping_postal_code}<br>
          ${order.shipping_country}<br>
          Phone: ${order.shipping_phone}
        </p>
      </div>

      <table style="width: 100%; border-collapse: collapse; margin-bottom: 30px;">
        <thead>
          <tr style="background: #2c3e50; color: white;">
            <th style="padding: 10px; text-align: left;">Product</th>
            <th style="padding: 10px; text-align: center;">Quantity</th>
            <th style="padding: 10px; text-align: right;">Unit Price</th>
            <th style="padding: 10px; text-align: right;">Total</th>
          </tr>
        </thead>
        <tbody>
          ${itemsHTML}
        </tbody>
      </table>

      <div style="text-align: right; margin-bottom: 30px;">
        <p><strong>Subtotal:</strong> $${order.subtotal.toFixed(2)}</p>
        <p><strong>Tax:</strong> $${order.tax.toFixed(2)}</p>
        <p><strong>Shipping:</strong> $${order.shipping_fee.toFixed(2)}</p>
        <h3 style="color: #2c3e50;"><strong>Total:</strong> $${order.total_amount.toFixed(2)}</h3>
      </div>

      <div style="background: #f8f9fa; padding: 15px; border-radius: 8px; text-align: center;">
        <p style="margin: 0; color: #7f8c8d;">Thank you for your order!</p>
        <p style="margin: 5px 0 0 0; color: #7f8c8d;">For questions, contact us at support@espressolab.com</p>
      </div>
    </body>
    </html>
  `
}

function generateCustomerEmailHTML(order: any, type: string): string {
  let message = ''
  
  switch (type) {
    case 'order_placed':
      message = 'Thank you for your order! We have received your order and will process it shortly.'
      break
    case 'payment_confirmed':
      message = 'Your payment has been confirmed. We are now processing your order.'
      break
    case 'order_shipped':
      message = `Your order has been shipped! Tracking number: ${order.tracking_number || 'Will be updated soon'}`
      break
  }

  return `
    <!DOCTYPE html>
    <html>
    <body style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; padding: 20px;">
      <div style="text-align: center; margin-bottom: 30px;">
        <h1 style="color: #2c3e50;">THE ESPRESSO LAB</h1>
      </div>

      <div style="background: #f8f9fa; padding: 20px; border-radius: 8px; margin-bottom: 20px;">
        <h2>Hello ${order.profiles.full_name || 'Valued Customer'},</h2>
        <p>${message}</p>
        <p><strong>Order Number:</strong> ${order.order_number}</p>
        <p><strong>Total Amount:</strong> $${order.total_amount.toFixed(2)}</p>
      </div>

      <div style="text-align: center; margin: 30px 0;">
        <a href="${SUPABASE_URL}/orders/${order.id}" 
           style="background: #2c3e50; color: white; padding: 12px 30px; text-decoration: none; border-radius: 5px; display: inline-block;">
          View Order Details
        </a>
      </div>

      <p style="color: #7f8c8d; text-align: center;">
        Please find your invoice attached to this email.
      </p>
    </body>
    </html>
  `
}

function generateAdminEmailHTML(order: any): string {
  const itemsList = order.order_items.map((item: any) => 
    `<li>${item.product_name} x ${item.quantity} - $${item.total_price.toFixed(2)}</li>`
  ).join('')

  return `
    <!DOCTYPE html>
    <html>
    <body style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; padding: 20px;">
      <h2 style="color: #2c3e50;">New Order Received</h2>
      
      <div style="background: #f8f9fa; padding: 20px; border-radius: 8px; margin-bottom: 20px;">
        <p><strong>Order Number:</strong> ${order.order_number}</p>
        <p><strong>Customer:</strong> ${order.profiles.full_name} (${order.profiles.email})</p>
        <p><strong>Total Amount:</strong> $${order.total_amount.toFixed(2)}</p>
        <p><strong>Payment Method:</strong> ${order.payment_method}</p>
        <p><strong>Status:</strong> ${order.status}</p>
      </div>

      <h3>Order Items:</h3>
      <ul>${itemsList}</ul>

      <h3>Shipping Address:</h3>
      <p>
        ${order.shipping_full_name}<br>
        ${order.shipping_address_line1}<br>
        ${order.shipping_address_line2 ? order.shipping_address_line2 + '<br>' : ''}
        ${order.shipping_city}, ${order.shipping_state} ${order.shipping_postal_code}<br>
        ${order.shipping_country}<br>
        Phone: ${order.shipping_phone}
      </p>

      <div style="text-align: center; margin: 30px 0;">
        <a href="${SUPABASE_URL}/admin/orders/${order.id}" 
           style="background: #2c3e50; color: white; padding: 12px 30px; text-decoration: none; border-radius: 5px; display: inline-block;">
          View in Admin Portal
        </a>
      </div>
    </body>
    </html>
  `
}

async function generateInvoicePDF(html: string): Promise<string> {
  // For production, use a service like Puppeteer or PDFShift
  // For now, return base64 encoded HTML as placeholder
  return btoa(html)
}
