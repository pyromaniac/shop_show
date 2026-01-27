# frozen_string_literal: true

require_relative '../../lib/framework/sequence'
require_relative '../../lib/framework/transaction'
require_relative 'calculate'
require_relative 'discounts_provider'
require_relative 'persist'
require_relative 'shipping_provider'
require_relative '../shipment/create'

# Supports:
# - Objects as functions: composes callables into a single entry point.
# - Dependency Injection (constructor): dependencies are passed into the operation.
# - Composition over inheritance: behavior is built by wiring collaborators.
# - Functional core / imperative shell: delegates pure calculation to the core.
# - Protocol-based polymorphism (uniform step interface): steps share a tiny contract.
# - Composition (pipelines/steps): composes steps via Sequence.
# - Transaction + after_commit: handled by the Transaction step.
# - Railway Oriented Programming (success/failure pipelines): failures are values.

class Order::Create
  def self.operation(create_shipment: nil, order_calculator: nil)
    create_shipment ||= Shipment::Create.new
    calculate_step = order_calculator ? Order::Calculate.new(calculator: order_calculator) : Order::Calculate.new

    Sequence.new(steps: [
      Order::DiscountsProvider.new,
      Order::ShippingProvider.new,
      calculate_step,
      Transaction.new(Order::Persist.new, on_success: create_shipment)
    ])
  end
end
