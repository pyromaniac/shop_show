# frozen_string_literal: true

# Supports:
# - Objects as functions: exposes a single #call entry point.
# - Dependency Injection (constructor): calculator is injected via dry-initializer.
# - Functional core / imperative shell: delegates pure calculation to the core.
# - Single Responsibility: calculates totals only.

class Order::Calculate
  extend Dry::Initializer

  option :calculator, default: -> { Checkout::OrderCalculator.new }

  def call(_, cart:, discounts: nil, shipping: nil, **)
    return Result.failure(errors: 'missing_discounts') unless discounts
    return Result.failure(errors: 'missing_shipping') unless shipping

    calculation = calculator.call(
      cart_lines: cart.cart_lines,
      currency: cart.currency,
      discounts:,
      shipping:
    )

    Result.success(calculation:)
  end
end
