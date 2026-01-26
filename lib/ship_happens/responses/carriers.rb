# frozen_string_literal: true

# Supports:
# - Typed data contracts: enforces response shape and types.
# - Gateway / Anti-Corruption Layer: external payloads stay localized.
# - Single Responsibility: one response shape per class.

class ShipHappens::Responses::Carriers < Dry::Struct
  transform_keys { |key| key.underscore.to_sym }

  attribute :carriers, Types::Array do
    attribute :id, Types::String
    attribute :name, Types::String
    attribute :price, Types::Decimal
  end
end
