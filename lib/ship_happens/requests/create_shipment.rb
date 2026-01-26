# frozen_string_literal: true

# Supports:
# - Single Responsibility: one request shape per class.
# - Typed data contracts: required fields are explicit.
# - Open/Closed: new request types are additive.

class ShipHappens::Requests::CreateShipment < ShipHappens::Request
  attribute :shipment do
    attribute :carrier_id, Types::String
    attribute :address, Types::String
  end

  def path
    'shipments'
  end
end
