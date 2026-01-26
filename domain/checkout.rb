# frozen_string_literal: true

# Supports:
# - Dependency Inversion: callers require a single entry point, not concrete files.
# - Typed data contracts: centralizes typed domain structures and calculators.
# - Composition: wires small objects into a cohesive unit.

require 'dry-struct'
require 'dry-initializer'
require 'money'
require_relative '../app/types'

require_relative 'checkout/adjustment_data'
require_relative 'checkout/line_calculation'
require_relative 'checkout/order_calculation'
require_relative 'checkout/line_calculator'
require_relative 'checkout/discount_calculator'
require_relative 'checkout/order_calculator'
