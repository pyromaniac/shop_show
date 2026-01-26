# frozen_string_literal: true

require_relative 'calculate'
require_relative 'discounts_provider'
require_relative 'persist'
require_relative 'shipping_provider'
# Supports:
# - Objects as functions: exposes a single #call entry point.
# - Dependency Injection (constructor): calculator is injected via dry-initializer.
# - Composition over inheritance: behavior is built by wiring collaborators.
# - Functional core / imperative shell: delegates pure calculation to the core.
# - Protocol-based polymorphism (uniform step interface): steps share a tiny contract.
# - Composition (pipelines/steps): manual step sequencing with explicit data flow.

class Order::Create
  extend Dry::Initializer

  option :discounts_provider, default: -> { Order::DiscountsProvider.new }
  option :shipping_provider, default: -> { Order::ShippingProvider.new }
  option :calculate_order, default: -> { Order::Calculate.new }
  option :persist, default: -> { Order::Persist.new }

  def call(params, **context)
    context = context.merge(discounts_provider.call(params, **context))
    context = context.merge(shipping_provider.call(params, **context))
    context = context.merge(calculate_order.call(params, **context))

    persisted_context = ActiveRecord::Base.transaction do
      persist.call(params, **context)
    end

    context.merge(persisted_context)
  end
end
