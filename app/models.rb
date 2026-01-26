# frozen_string_literal: true

require 'active_record'
require 'active_support/concern'
require 'money'

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end

# Simple monetize concern for Money gem integration
module Monetize
  extend ActiveSupport::Concern

  class_methods do
    def monetize(*attributes)
      attributes.each do |attribute|
        define_method(attribute) do
          Money.new(public_send(:"#{attribute}_cents"), currency)
        end

        define_method(:"#{attribute}=") do |money|
          public_send(:"#{attribute}_cents=", money.cents)
        end
      end
    end
  end
end

# ============================================================================
# MODELS: ActiveRecord entities (mutable, persistent)
# ============================================================================

class Cart < ApplicationRecord
  has_many :cart_lines, dependent: :destroy
end

class CartLine < ApplicationRecord
  include Monetize

  belongs_to :cart

  delegate :currency, to: :cart
  monetize :unit_price
end

class Discount < ApplicationRecord
end

class Order < ApplicationRecord
  include Monetize

  has_many :order_lines, dependent: :destroy
  has_one :shipment, dependent: :destroy

  monetize :lines_total, :discount_total, :subtotal, :shipping, :total
end

class OrderLine < ApplicationRecord
  include Monetize

  belongs_to :order
  has_many :line_adjustments, dependent: :destroy

  monetize :unit_price, :line_total, :discount_total, :subtotal
end

class LineAdjustment < ApplicationRecord
  include Monetize

  belongs_to :order_line

  monetize :amount
end

class Shipment < ApplicationRecord
  belongs_to :order
end
