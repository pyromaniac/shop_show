# frozen_string_literal: true

require_relative '../../lib/framework/sequence'
require_relative 'calculate'
require_relative 'discounts_provider'
require_relative 'persist'
require_relative 'shipping_provider'
require_relative '../shipment/create'

# Supports:
# - Objects as functions: exposes a single #call entry point.
# - Dependency Injection (constructor): collaborators are injected via dry-initializer.
# - Composition over inheritance: behavior is built by wiring collaborators.
# - Functional core / imperative shell: delegates pure calculation to the core.
# - Protocol-based polymorphism (uniform step interface): steps share a tiny contract.
# - Composition (pipelines/steps): composes steps via Sequence.
# - Transaction + after_commit: shipment is created after persistence succeeds.
# - Railway Oriented Programming (success/failure pipelines): failures are values.

class Order::Create
  extend Dry::Initializer

  option :persist, default: -> { Order::Persist.new }
  option :create_shipment, default: -> { Shipment::Create.new }

  def self.operation(create_shipment: nil)
    Sequence.new(steps: [
      Order::DiscountsProvider.new,
      Order::ShippingProvider.new,
      Order::Calculate.new,
      new(create_shipment: create_shipment || Shipment::Create.new)
    ])
  end

  def call(params, **context)
    shipment_result = Result.success
    persist_result = nil

    ActiveRecord::Base.transaction do |transaction|
      persist_result = persist.call(params, **context)
      raise ActiveRecord::Rollback if persist_result.failure?

      order = persist_result.context[:order]
      transaction.after_commit do
        shipment_result = create_shipment.call(params, order:)
      end
    end

    return persist_result if persist_result.failure?
    return shipment_result if shipment_result.failure?

    Result.success(**persist_result.context.merge(shipment_result.context))
  end

end
