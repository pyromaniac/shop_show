# frozen_string_literal: true

# Supports:
# - Gateway / Anti-Corruption Layer: isolates transport from application logic.
# - Dependency Injection (constructor): endpoint and behavior are explicit.
# - Objects as functions: #call makes the client composable.
# - Interface Segregation: depends only on the request protocol.
# - Functional core / imperative shell: this is the input/output boundary.

class ShipHappens::Client
  extend Dry::Initializer

  option :endpoint, Types::String.constrained(format: /\Ahttps?/), default: proc { ENV.fetch('SHIP_HAPPENS_ENDPOINT') }
  option :raise_error, Types::Bool, default: proc { true }

  def call(request_object)
    response = faraday.run_request(
      request_object.method,
      request_object.path,
      request_object.to_payload,
      request_object.headers
    )

    response.body
  end

  private

  def faraday
    @faraday ||= Faraday.new(url: endpoint, request: { open_timeout: 5 }) do |builder|
      builder.request :json
      builder.response :json
      builder.response :raise_error if raise_error
    end
  end
end
