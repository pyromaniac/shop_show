# frozen_string_literal: true

require 'dry-struct'
require_relative '../../app/types'

# Supports:
# - Railway Oriented Programming (success/failure pipelines): failures are values.
# - Typed data contracts: context and error shapes are explicit.
# - Single Responsibility: represents success or failure with context.

class Result < Dry::Struct
  attribute :context, Types::Hash.map(Types::Symbol, Types::Any)
  attribute :errors, Types::Array.of(Types::Coercible::String)

  def self.success(**context)
    new(context:, errors: [])
  end

  def self.failure(errors:)
    errors = Array(errors)
    new(context: {}, errors:)
  end

  def success?
    errors.empty?
  end

  def failure?
    !success?
  end

  def with_context(context)
    self.class.new(context:, errors:)
  end
end
