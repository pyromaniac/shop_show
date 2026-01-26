# frozen_string_literal: true

# Supports:
# - Objects as functions: exposes a single #call entry point.
# - Single Responsibility: persistence only, no orchestration.
# - Interface Segregation: depends on the narrow data it needs.

class Order::Persist
  def call(cart:, calculation:)
    order = create_order(calculation, cart.currency)
    create_order_lines(order, calculation.lines, cart.currency)

    order
  end

  private

  def create_order(calculation, currency)
    Order.create!(
      lines_total_cents: calculation.lines_total.cents,
      discount_total_cents: calculation.discount_total.cents,
      subtotal_cents: calculation.subtotal.cents,
      shipping_cents: calculation.shipping.cents,
      total_cents: calculation.total.cents,
      currency:
    )
  end

  def create_order_lines(order, lines, currency)
    lines.each do |line|
      order_line = order.order_lines.create!(
        product_name: line.product_name,
        quantity: line.quantity,
        unit_price_cents: line.unit_price.cents,
        line_total_cents: line.line_total.cents,
        discount_total_cents: line.discount_total.cents,
        subtotal_cents: line.subtotal.cents,
        currency:
      )

      create_adjustments(order_line, line.adjustments, currency)
    end
  end

  def create_adjustments(order_line, adjustments, currency)
    adjustments.each do |adjustment|
      order_line.line_adjustments.create!(
        label: adjustment.label,
        amount_cents: adjustment.amount.cents,
        currency:,
        percentage: adjustment.percentage
      )
    end
  end
end
