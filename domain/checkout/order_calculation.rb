# frozen_string_literal: true

# Supports:
# - Typed data contracts: enforces order calculation shape and types.
# - Functional core / imperative shell: immutable data for pure calculations.
# - Single Responsibility: one value object per concept.
# - Data/behavior separation with immutable value objects: data only, no logic.

module Checkout
  class OrderCalculation < Dry::Struct
    attribute :lines, Types::Array.of(Types::Instance(LineCalculation))
    attribute :lines_total, Types::Money
    attribute :discount_total, Types::Money
    attribute :subtotal, Types::Money
    attribute :shipping, Types::Money
    attribute :total, Types::Money
  end
end
