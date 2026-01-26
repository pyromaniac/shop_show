# frozen_string_literal: true

# Supports:
# - Objects as functions: a callable object that returns deterministic data.
# - Functional core / imperative shell: pure calculation, no side effects.
# - Single Responsibility: applies discounts to line calculations.
# - Pure recalculation: output is fully determined by inputs.

module Checkout
  class DiscountCalculator
    extend Dry::Initializer

    option :rounding, default: -> { BigDecimal::ROUND_HALF_UP }

    def call(lines:, discounts:)
      return lines if discounts.empty?

      discounts.reduce(lines) do |current_lines, discount|
        current_lines.map { |line| apply_discount(line, discount) }
      end
    end

    private

    def apply_discount(line, discount)
      ratio = discount.percentage / BigDecimal('100')
      discount_amount = line.subtotal * ratio.round(4, rounding)

      adjustment = AdjustmentData.new(
        label: discount.name,
        amount: discount_amount,
        percentage: discount.percentage
      )

      line.new(
        discount_total: line.discount_total + discount_amount,
        subtotal: line.subtotal - discount_amount,
        adjustments: line.adjustments + [adjustment]
      )
    end
  end
end
