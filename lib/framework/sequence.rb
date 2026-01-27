# frozen_string_literal: true

require 'dry-initializer'
require_relative '../../app/types'
require_relative 'result'

# Supports:
# - Composition (pipelines/steps): composes callables into a workflow.
# - Railway Oriented Programming (success/failure pipelines): stops on failure.
# - Protocol-based polymorphism (uniform step interface): steps share #call.

class Sequence
  extend Dry::Initializer

  option :steps, Types::Array.of(Types::Interface(:call))

  def call(params, **context)
    accumulated_context = context
    result = Result.success(**accumulated_context)

    steps.each do |step|
      step_result = step.call(params, **accumulated_context)
      return step_result.with_context(accumulated_context) if step_result.failure?

      accumulated_context = accumulated_context.merge(step_result.context)
      result = step_result.with_context(accumulated_context)
    end

    result
  end
end
