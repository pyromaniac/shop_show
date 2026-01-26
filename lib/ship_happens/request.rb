# frozen_string_literal: true

# Supports:
# - Typed data contracts: enforces request shape and types.
# - Open/Closed: new requests are subclasses, no client changes.
# - Single Responsibility: request objects only define payload and routing.
# - Gateway / Anti-Corruption Layer: external payloads stay localized.

class ShipHappens::Request < Dry::Struct
  def method
    :post
  end

  def path
    raise NotImplementedError
  end

  def to_payload
    to_hash.deep_transform_keys { |key| key.to_s.camelize(:lower) }
  end

  def headers
    {}
  end
end
