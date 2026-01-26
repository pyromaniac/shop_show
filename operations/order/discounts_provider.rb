# frozen_string_literal: true

# Supports:
# - Objects as functions: exposes a single #call entry point.
# - Single Responsibility: reads discounts only.
# - Interface Segregation: depends on a narrow, read-only interface.

class Order::DiscountsProvider
  def call(_, **)
    { discounts: Discount.all.to_a }
  end
end
