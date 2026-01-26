# frozen_string_literal: true

# Supports:
# - Typed data contracts: enforces adjustment shape and types.
# - Functional core / imperative shell: immutable data for pure calculations.
# - Single Responsibility: one value object per concept.
# - Data/behavior separation with immutable value objects: data only, no logic.

module Checkout
  class AdjustmentData < Dry::Struct
    attribute :label, Types::String
    attribute :amount, Types::Money
    attribute :percentage, Types::Percentage.optional
  end
end
