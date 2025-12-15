# Supabase Edge Functions

These Edge Functions handle business logic and notifications for The Espresso Lab.

## Functions

### 1. send-order-notification
**Trigger:** When a new order is placed or status changes
**Purpose:** Sends email notifications to admin and customer with invoice PDF

**Environment Variables Required:**
- `RESEND_API_KEY` - API key for Resend email service
- `ADMIN_EMAIL` - Admin email address for order notifications

**Usage:**
```typescript
// Call from database trigger or client
const { data, error } = await supabase.functions.invoke('send-order-notification', {
  body: { 
    order_id: 'uuid-here',
    type: 'order_placed' // or 'payment_confirmed', 'order_shipped'
  }
})
```

### 2. send-qc-notification
**Trigger:** When QC report is completed by admin
**Purpose:** Sends QC report results to customer via email

**Environment Variables Required:**
- `RESEND_API_KEY` - API key for Resend email service

**Usage:**
```typescript
const { data, error } = await supabase.functions.invoke('send-qc-notification', {
  body: { report_id: 'uuid-here' }
})
```

## Deployment

Deploy functions using Supabase CLI:

```bash
# Deploy all functions
supabase functions deploy

# Deploy specific function
supabase functions deploy send-order-notification
supabase functions deploy send-qc-notification
```

## Setting Environment Variables

```bash
supabase secrets set RESEND_API_KEY=your_api_key_here
supabase secrets set ADMIN_EMAIL=admin@espressolab.com
```

## Local Development

```bash
# Start Supabase locally
supabase start

# Serve functions locally
supabase functions serve

# Test function
curl -i --location --request POST 'http://localhost:54321/functions/v1/send-order-notification' \
  --header 'Authorization: Bearer YOUR_ANON_KEY' \
  --header 'Content-Type: application/json' \
  --data '{"order_id":"test-uuid"}'
```

## Email Service Setup

This project uses [Resend](https://resend.com) for transactional emails.

1. Sign up at resend.com
2. Verify your domain
3. Get your API key
4. Set the environment variable in Supabase

## Database Triggers

To automatically invoke these functions, create database triggers:

```sql
-- Trigger on order creation
CREATE OR REPLACE FUNCTION notify_order_placed()
RETURNS TRIGGER AS $$
BEGIN
  PERFORM net.http_post(
    url := current_setting('app.supabase_functions_url') || '/send-order-notification',
    headers := jsonb_build_object('Content-Type', 'application/json'),
    body := jsonb_build_object('order_id', NEW.id, 'type', 'order_placed')
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER order_placed_trigger
  AFTER INSERT ON orders
  FOR EACH ROW
  EXECUTE FUNCTION notify_order_placed();

-- Trigger on QC report completion
CREATE OR REPLACE FUNCTION notify_qc_completed()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.completed_at IS NOT NULL AND OLD.completed_at IS NULL THEN
    PERFORM net.http_post(
      url := current_setting('app.supabase_functions_url') || '/send-qc-notification',
      headers := jsonb_build_object('Content-Type', 'application/json'),
      body := jsonb_build_object('report_id', NEW.id)
    );
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER qc_completed_trigger
  AFTER UPDATE ON qc_reports
  FOR EACH ROW
  EXECUTE FUNCTION notify_qc_completed();
```
