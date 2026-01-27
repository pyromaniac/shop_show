# frozen_string_literal: true

# Supports:
# - Objects as functions: a callable object that returns deterministic data.
# - Functional core / imperative shell: pure calculation, no side effects.
# - Single Responsibility: picks the single best discount set.
# - Pure recalculation: output is fully determined by inputs.

module Checkout
  class BestDiscountCalculator
    extend Dry::Initializer

    option :rounding, default: -> { BigDecimal::ROUND_HALF_UP }

    def call(lines:, discounts:)
      return lines if discounts.empty? || lines.empty?

      discounts
        .map { |discount| apply_discount_set(lines, discount) }
        .max_by { |discounted_lines| total_discount(discounted_lines) }
    end

    private

    def apply_discount_set(lines, discount)
      lines.map { |line| apply_discount(line, discount) }
    end

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

    def total_discount(lines)
      zero = Money.new(0, lines.first.subtotal.currency)
      lines.sum(zero, &:discount_total)
    end
  end
end
