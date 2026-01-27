# frozen_string_literal: true

require 'dry-initializer'
require_relative '../../app/types'
require_relative 'result'

# Supports:
# - Composition (pipelines/steps): wraps a step in a transaction boundary.
# - Railway Oriented Programming (success/failure pipelines): returns Result values.
# - Transaction + after_commit: invokes callbacks only after commit.

class Transaction
  extend Dry::Initializer

  param :component, Types::Interface(:call)
  option :on_success, Types::Interface(:call).optional, default: -> { nil }

  def call(params, **context)
    result = nil
    callback_context = {}
    callback_failure = nil

    ActiveRecord::Base.transaction do |transaction|
      result = component.call(params, **context)
      raise ActiveRecord::Rollback if result.failure?

      if on_success
        transaction.after_commit do
          callback_result = on_success.call(params, **result.context)
          if callback_result.failure?
            callback_failure = callback_result.with_context(result.context.merge(callback_context))
          else
            callback_context = callback_context.merge(callback_result.context)
          end
        end
      end
    end

    return result if result.failure?
    return callback_failure if callback_failure

    result.with_context(result.context.merge(callback_context))
  end
end
