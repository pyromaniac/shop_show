# frozen_string_literal: true

# Supports:
# - Typed data contracts: enforces line calculation shape and types.
# - Functional core / imperative shell: immutable data for pure calculations.
# - Single Responsibility: one value object per concept.
# - Data/behavior separation with immutable value objects: data only, no logic.

module Checkout
  class LineCalculation < Dry::Struct
    attribute :product_name, Types::String
    attribute :unit_price, Types::Money
    attribute :quantity, Types::Integer
    attribute :line_total, Types::Money
    attribute :discount_total, Types::Money
    attribute :subtotal, Types::Money
    attribute :adjustments, Types::Array.of(Types::Instance(AdjustmentData))
  end
end
