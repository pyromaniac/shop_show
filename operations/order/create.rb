# frozen_string_literal: true

require_relative 'persist'
# Supports:
# - Objects as functions: exposes a single #call entry point.
# - Dependency Injection (constructor): calculator is injected via dry-initializer.
# - Composition over inheritance: behavior is built by wiring collaborators.
# - Functional core / imperative shell: delegates pure calculation to the core.
# - Single Responsibility: persistence is delegated to Order::Persist.

class Order::Create
  extend Dry::Initializer

  option :calculator, default: -> { Checkout::OrderCalculator.new }
  option :persist, default: -> { Order::Persist.new }

  def call(cart:)
    calculation = calculator.call(
      cart_lines: cart.cart_lines,
      currency: cart.currency
    )

    ActiveRecord::Base.transaction do
      persist.call(cart:, calculation:)
    end
  end
end
