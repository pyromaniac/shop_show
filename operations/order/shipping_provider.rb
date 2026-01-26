# frozen_string_literal: true

# Supports:
# - Objects as functions: exposes a single #call entry point.
# - Dependency Injection (constructor): rates can be replaced.
# - Single Responsibility: resolves shipping cost only.

class Order::ShippingProvider
  extend Dry::Initializer

  DEFAULT_SHIPPING_RATES = {
    'standard' => 800,
    'express' => 1500
  }.freeze

  option :shipping_rates, Types::Hash.map(Types::String, Types::Integer), default: -> { DEFAULT_SHIPPING_RATES }

  def call(params, cart:, **)
    carrier_id = params[:carrier_id]
    cents = shipping_rates.fetch(carrier_id)

    { shipping: Money.new(cents, cart.currency) }
  end
end
