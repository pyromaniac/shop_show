# frozen_string_literal: true

# Supports:
# - Single Responsibility: one request shape per class.
# - Typed data contracts: required fields are explicit.
# - Open/Closed: new request types are additive.

class ShipHappens::Requests::GetCarriers < ShipHappens::Request
  attribute :address, Types::String

  def path
    'carriers'
  end

  def method
    :get
  end
end
