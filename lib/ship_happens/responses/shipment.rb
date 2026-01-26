# frozen_string_literal: true

# Supports:
# - Typed data contracts: enforces response shape and types.
# - Gateway / Anti-Corruption Layer: external payloads stay localized.
# - Single Responsibility: one response shape per class.

class ShipHappens::Responses::Shipment < Dry::Struct
  transform_keys { |key| key.underscore.to_sym }

  attribute :id, Types::String
  attribute :status, Types::String
  attribute :tracking_number, Types::String
  attribute :tracking_url, Types::String
end
