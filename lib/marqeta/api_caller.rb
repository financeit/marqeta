require 'json'
require 'faraday'
require 'marqeta/errors'

module Marqeta
  class ApiCaller
    def initialize(endpoint, params = {})
      @endpoint = endpoint
      @connection = Faraday.new(url: Marqeta.configuration.base_url) do |conn|
        conn.request :basic_auth, Marqeta.configuration.username, Marqeta.configuration.password
        conn.response :logger, logger
        conn.params = params
        conn.headers['Content-Type'] = 'application/json'
      end
    end

    def full_url
      @connection.build_url(@endpoint).to_s
    end

    def get
      perform_action { @connection.get(@endpoint) }
    end

    def post(payload)
      json_payload = payload.to_json
      perform_action { @connection.post(@endpoint, json_payload) }
    end

    def put(payload)
      json_payload = payload.to_json
      perform_action { @connection.put(@endpoint, json_payload) }
    end

    private

    attr_reader :endpoint, :connection

    def perform_action
      response = yield
      handle_successful_response response
    rescue Faraday::ClientError => e
      handle_exception_with_response(e)
    rescue *HttpError::ERROR_LIST => e
      handle_http_error e
    end

    def connection
      @connection ||= Faraday.new(url: Marqeta.configuration.base_url + endpoint) do |conn|
        conn.request :authorization, :basic, Marqeta.configuration.username, Marqeta.configuration.password
        conn.headers['Content-Type'] = 'application/json'
      end
    end

    def logger
      Marqeta.configuration.logger
    end

    def handle_successful_response(response)
      JSON.parse(response.body)
    rescue JSON::ParserError
      {}
    end

    def handle_exception_with_response(e)
      error = ApiError.new(e.response)
      logger.error(error.to_s)
      raise error
    end

    def handle_http_error(e)
      error = HttpError.new("#{e.class}: #{e.message}")
      logger.error(error)
      raise error
    end
  end
end
