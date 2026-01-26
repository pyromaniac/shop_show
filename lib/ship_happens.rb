# frozen_string_literal: true

# Supports:
# - Gateway / Anti-Corruption Layer: single entry point for the shipping boundary.
# - Typed data contracts: centralizes typed request definitions.
# - Dependency Inversion: callers require this entry point, not concrete files.

require 'dry-struct'
require 'dry-initializer'
require 'faraday'
require 'active_support/core_ext/hash/keys'
require 'active_support/core_ext/string/inflections'
require_relative '../app/types'

module ShipHappens
  module Requests; end
end

require_relative 'ship_happens/client'
require_relative 'ship_happens/request'
require_relative 'ship_happens/requests/get_carriers'
require_relative 'ship_happens/requests/create_shipment'
