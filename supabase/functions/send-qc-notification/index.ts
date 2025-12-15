// =====================================================
// SUPABASE EDGE FUNCTION: Send QC Notification
// =====================================================
// Triggered when QC report is completed
// Sends email to customer with QC results
// =====================================================

import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

const RESEND_API_KEY = Deno.env.get('RESEND_API_KEY')
const SUPABASE_URL = Deno.env.get('SUPABASE_URL')
const SUPABASE_SERVICE_ROLE_KEY = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')

interface QCNotificationPayload {
  report_id: string
}

serve(async (req: Request) => {
  try {
    const { report_id }: QCNotificationPayload = await req.json()

    const supabase = createClient(
      SUPABASE_URL!,
      SUPABASE_SERVICE_ROLE_KEY!
    )

    // Fetch QC report with related data
    const { data: report, error: reportError } = await supabase
      .from('qc_reports')
      .select(`
        *,
        qc_appointments (
          *,
          profiles:user_id (
            email,
            full_name
          )
        ),
        orders (
          order_number
        ),
        qc_answers (
          question_text,
          answer_value,
          rating,
          notes
        )
      `)
      .eq('id', report_id)
      .single()

    if (reportError || !report) {
      throw new Error(`QC Report not found: ${reportError?.message}`)
    }

    const customer = report.qc_appointments.profiles
    const order = report.orders

    // Send email to customer
    await sendEmail({
      to: customer.email,
      subject: `QC Report Ready - Order ${order.order_number}`,
      html: generateQCEmailHTML(report, customer, order)
    })

    // Create notification
    await supabase.from('notifications').insert({
      user_id: report.qc_appointments.user_id,
      type: 'qc_completed',
      title: 'QC Report Completed',
      message: `Your QC report for order ${order.order_number} is ready to view.`,
      reference_id: report.id,
      email_sent: true
    })

    return new Response(
      JSON.stringify({ success: true, report_id }),
      { headers: { 'Content-Type': 'application/json' } }
    )

  } catch (error: unknown) {
    console.error('Error sending QC notification:', error)
    return new Response(
      JSON.stringify({ error: (error as Error).message }),
      { status: 500, headers: { 'Content-Type': 'application/json' } }
    )
  }
})

async function sendEmail({ to, subject, html }: { to: string; subject: string; html: string }) {
  const response = await fetch('https://api.resend.com/emails', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${RESEND_API_KEY}`
    },
    body: JSON.stringify({
      from: 'The Espresso Lab <qc@espressolab.com>',
      to,
      subject,
      html
    })
  })

  if (!response.ok) {
    throw new Error(`Failed to send email: ${await response.text()}`)
  }

  return response.json()
}

function generateQCEmailHTML(report: any, customer: any, order: any): string {
  const statusColor = report.passed ? '#27ae60' : '#e74c3c'
  const statusText = report.passed ? 'PASSED' : 'NEEDS ATTENTION'
  
  const answersHTML = report.qc_answers.map((answer: any) => `
    <div style="background: #f8f9fa; padding: 15px; border-radius: 5px; margin-bottom: 15px;">
      <p style="margin: 0 0 10px 0; font-weight: bold;">${answer.question_text}</p>
      ${answer.rating ? `<p style="margin: 0 0 5px 0;">Rating: ${'⭐'.repeat(answer.rating)}</p>` : ''}
      <p style="margin: 0; color: #7f8c8d;">${answer.answer_value || answer.notes || 'N/A'}</p>
    </div>
  `).join('')

  const imagesHTML = report.images_urls && report.images_urls.length > 0 
    ? `
      <h3>Inspection Images</h3>
      <div style="display: flex; gap: 10px; flex-wrap: wrap;">
        ${report.images_urls.map((url: string) => `
          <img src="${url}" alt="QC Image" style="max-width: 200px; border-radius: 5px; border: 1px solid #ddd;">
        `).join('')}
      </div>
    `
    : ''

  return `
    <!DOCTYPE html>
    <html>
    <body style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; padding: 20px;">
      <div style="text-align: center; margin-bottom: 30px;">
        <h1 style="color: #2c3e50;">THE ESPRESSO LAB</h1>
        <p style="color: #7f8c8d;">Quality Control Report</p>
      </div>

      <div style="background: ${statusColor}; color: white; padding: 20px; border-radius: 8px; text-align: center; margin-bottom: 30px;">
        <h2 style="margin: 0;">QC Status: ${statusText}</h2>
      </div>

      <div style="background: #f8f9fa; padding: 20px; border-radius: 8px; margin-bottom: 20px;">
        <p><strong>Hello ${customer.full_name},</strong></p>
        <p>Your quality control inspection has been completed for order <strong>${order.order_number}</strong>.</p>
        <p><strong>Overall Rating:</strong> ${'⭐'.repeat(report.overall_rating || 0)}</p>
        ${report.overall_notes ? `<p><strong>Inspector Notes:</strong> ${report.overall_notes}</p>` : ''}
      </div>

      <h3>Inspection Details</h3>
      ${answersHTML}

      ${imagesHTML}

      <div style="text-align: center; margin: 30px 0;">
        <a href="${SUPABASE_URL}/qc-reports/${report.id}" 
           style="background: #2c3e50; color: white; padding: 12px 30px; text-decoration: none; border-radius: 5px; display: inline-block;">
          View Full Report & Provide Feedback
        </a>
      </div>

      <div style="background: #f8f9fa; padding: 15px; border-radius: 8px; text-align: center; margin-top: 30px;">
        <p style="margin: 0; color: #7f8c8d;">
          ${report.passed 
            ? 'Your order will be shipped shortly. You will receive a tracking number soon.' 
            : 'Our team will contact you shortly to discuss the next steps.'}
        </p>
      </div>
    </body>
    </html>
  `
}
