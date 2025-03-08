/*
  # Update users and orders relationship

  1. Changes
    - Add foreign key constraint from orders.customer_id to users.id
    - Update RLS policies to ensure proper data access

  2. Security
    - Ensure users can only access their own orders
    - Maintain existing RLS policies
*/

-- Add foreign key constraint to orders table
ALTER TABLE orders
ADD CONSTRAINT fk_orders_customer
FOREIGN KEY (customer_id) REFERENCES users(id)
ON DELETE CASCADE;

-- Update orders RLS policies to use auth.uid()
DROP POLICY IF EXISTS "Users can read their own orders" ON orders;

CREATE POLICY "Users can read their own orders"
ON orders
FOR SELECT
TO authenticated
USING (customer_id = auth.uid());

-- Add policy for creating orders
CREATE POLICY "Users can create their own orders"
ON orders
FOR INSERT
TO authenticated
WITH CHECK (customer_id = auth.uid());

-- Add policy for updating orders
CREATE POLICY "Users can update their own orders"
ON orders
FOR UPDATE
TO authenticated
USING (customer_id = auth.uid());