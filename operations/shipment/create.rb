# frozen_string_literal: true

require_relative '../../lib/ship_happens'

# Supports:
# - Objects as functions: exposes a single #call entry point.
# - Dependency Injection (constructor): client is injected via dry-initializer.
# - Gateway / Anti-Corruption Layer: isolates external shipping details.
# - Single Responsibility: creates and synchronizes shipments only.

class Shipment::Create
  extend Dry::Initializer

  option :client, default: -> { ShipHappens::Client.new }

  def call(params, order:, **)
    carrier_id = params[:carrier_id]
    address = params[:address]

    shipment = order.create_shipment!(carrier_id:, address:)

    response = client.call(ShipHappens::Requests::CreateShipment.new(
      shipment: { carrier_id:, address: }
    ))

    if response.is_a?(ShipHappens::Responses::Errors)
      raise StandardError, response.errors.map(&:message).join(', ')
    end

    shipment.update!(
      external_id: response.id,
      status: response.status,
      tracking_number: response.tracking_number,
      tracking_url: response.tracking_url
    )

    { shipment: }
  end
end
