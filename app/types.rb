# frozen_string_literal: true

require 'dry-types'
require 'money'

Money.rounding_mode = BigDecimal::ROUND_HALF_UP

module Types
  include Dry.Types()

  Money = Instance(::Money)
  Percentage = Coercible::Decimal.constrained(gteq: 0, lteq: 100)
end
