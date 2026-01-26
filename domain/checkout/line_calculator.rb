# frozen_string_literal: true

# Supports:
# - Objects as functions: a callable object that returns deterministic data.
# - Functional core / imperative shell: pure calculation, no side effects.
# - Single Responsibility: only builds line calculations.
# - Pure recalculation: output is fully determined by inputs.

module Checkout
  class LineCalculator
    def call(cart_lines:, currency:)
      zero = Money.new(0, currency)

      cart_lines.map do |line|
        line_total = line.unit_price * line.quantity

        LineCalculation.new(
          product_name: line.product_name,
          unit_price: line.unit_price,
          quantity: line.quantity,
          line_total: line_total,
          discount_total: zero,
          subtotal: line_total,
          adjustments: []
        )
      end
    end
  end
end
