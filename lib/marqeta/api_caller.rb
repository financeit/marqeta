require 'json'
require 'rest-client'
require 'marqeta/errors'

module Marqeta
  class ApiCaller
    def initialize(endpoint, params = {})
      @endpoint = endpoint
      @endpoint += "?#{URI.encode_www_form(params)}" if params.any?
    end

    def get
      logger.info("GET: #{endpoint}")
      perform_action { resource.get }
    end

    def post(payload)
      json_payload = payload.to_json
      logger.info "POST: #{endpoint}, #{json_payload}"
      perform_action { resource.post(json_payload, content_type: 'application/json') }
    end

    def put(payload)
      json_payload = payload.to_json
      logger.info "PUT: #{endpoint}, #{json_payload}"
      perform_action { resource.put(json_payload, content_type: 'application/json') }
    end

    private

    attr_reader :endpoint

    def perform_action
      begin
        response = yield
        handle_successful_response response
      rescue RestClient::ExceptionWithResponse => e
        handle_exception_with_response e
      rescue *HttpError::ERROR_LIST => e
        handle_http_error e
      end
    end

    def resource
      @resource ||= RestClient::Resource.new(
        Marqeta.configuration.base_url + endpoint,
        Marqeta.configuration.username,
        Marqeta.configuration.password
      )
    end

    def logger
      Marqeta.configuration.logger
    end

    def handle_successful_response(response)
      logger.info("Response: #{response}")
      JSON.parse(response)
    rescue JSON::ParserError
      {}
    end

    def handle_exception_with_response(e)
      error = ApiError.new(e.response)
      logger.error(error)
      raise error
    end

    def handle_http_error(e)
      error = HttpError.new("#{e.class}: #{e.message}")
      logger.error(error)
      raise error
    end
  end
end
