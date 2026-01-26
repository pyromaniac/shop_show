# frozen_string_literal: true

require 'active_record'

# ============================================================================
# DATABASE SETUP: In-memory SQLite
# ============================================================================

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: ':memory:')

ActiveRecord::Schema.define do
  create_table :carts do |t|
    t.string :currency, null: false, default: 'USD'
  end

  create_table :cart_lines do |t|
    t.references :cart, null: false
    t.string :product_name, null: false
    t.integer :quantity, null: false
    t.integer :unit_price_cents, null: false
  end

  create_table :discounts do |t|
    t.string :name, null: false
    t.decimal :percentage, null: false
  end

  create_table :orders do |t|
    t.integer :lines_total_cents, null: false
    t.integer :discount_total_cents, null: false
    t.integer :subtotal_cents, null: false
    t.integer :shipping_cents, null: false
    t.integer :total_cents, null: false
    t.string :currency, null: false
  end

  create_table :order_lines do |t|
    t.references :order, null: false
    t.string :product_name, null: false
    t.integer :quantity, null: false
    t.integer :unit_price_cents, null: false
    t.integer :line_total_cents, null: false
    t.integer :discount_total_cents, null: false
    t.integer :subtotal_cents, null: false
    t.string :currency, null: false
  end

  create_table :line_adjustments do |t|
    t.references :order_line, null: false
    t.string :label, null: false
    t.integer :amount_cents, null: false
    t.string :currency, null: false
    t.decimal :percentage
  end

  create_table :shipments do |t|
    t.references :order, null: false
    t.string :carrier_id, null: false
    t.string :address, null: false
    t.string :external_id
    t.string :status
    t.string :tracking_number
    t.string :tracking_url
  end
end
