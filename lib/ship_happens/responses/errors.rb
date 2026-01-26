# frozen_string_literal: true

# Supports:
# - Typed data contracts: enforces response shape and types.
# - Gateway / Anti-Corruption Layer: external payloads stay localized.
# - Single Responsibility: one response shape per class.

class ShipHappens::Responses::Errors < Dry::Struct
  transform_keys { |key| key.underscore.to_sym }

  attribute :errors, Types::Array do
    attribute :path, Types::Array.of(Types::String)
    attribute :message, Types::String
  end
end
