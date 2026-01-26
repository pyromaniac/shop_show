# frozen_string_literal: true

# Supports:
# - Dependency Injection (constructor): calculators are injected via dry-initializer.
# - Composition (pipelines/steps): composes line, discount, and aggregation steps.
# - Open/Closed: swap calculators without changing this class.
# - Functional core / imperative shell: pure calculation, no side effects.
# - Pure recalculation: totals are deterministic from inputs.

module Checkout
  class OrderCalculator
    extend Dry::Initializer

    option :line_calculator, default: -> { LineCalculator.new }
    option :discount_calculator, default: -> { DiscountCalculator.new }

    def call(cart_lines:, currency:, discounts: [], shipping: nil)
      zero = Money.new(0, currency)
      shipping ||= zero

      lines = line_calculator.call(cart_lines:, currency:)
      lines = discount_calculator.call(lines:, discounts:)
      aggregate(lines:, shipping:, zero:)
    end

    private

    def aggregate(lines:, shipping:, zero:)
      lines_total = lines.sum(zero, &:line_total)
      discount_total = lines.sum(zero, &:discount_total)
      subtotal = lines_total - discount_total
      total = subtotal + shipping

      OrderCalculation.new(
        lines:,
        lines_total:,
        discount_total:,
        subtotal:,
        shipping:,
        total:
      )
    end
  end
end
