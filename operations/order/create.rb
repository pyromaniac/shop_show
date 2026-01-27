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
# - Dependency Injection (constructor): shipment creator is passed into the operation.
# - Composition over inheritance: behavior is built by wiring collaborators.
# - Functional core / imperative shell: delegates pure calculation to the core.
# - Protocol-based polymorphism (uniform step interface): steps share a tiny contract.
# - Composition (pipelines/steps): composes steps via Sequence.
# - Transaction + after_commit: handled by the Transaction step.
# - Railway Oriented Programming (success/failure pipelines): failures are values.

class Order::Create
  def self.operation(create_shipment: nil)
    Sequence.new(steps: [
      Order::DiscountsProvider.new,
      Order::ShippingProvider.new,
      Order::Calculate.new,
      Transaction.new(Order::Persist.new, on_success: create_shipment || Shipment::Create.new)
    ])
  end
end
