# frozen_string_literal: true

require 'faraday'
require 'json'

module Marqeta
  class ApiCaller
    attr_reader :endpoint, :params

    def initialize(endpoint, params = {})
      @endpoint = endpoint
      @params = params
    end

    def get
      response = connection.get(endpoint_with_params)
      log_request_and_response(:get, response)
      parse_response(response)
    end

    def post(payload)
      response = connection.post(endpoint_with_params, payload.to_json, content_type: 'application/json')
      log_request_and_response(:post, response)
      parse_response(response)
    end

    def put(payload)
      response = connection.put(endpoint_with_params, payload.to_json, content_type: 'application/json')
      log_request_and_response(:put, response)
      parse_response(response)
    end

    private

    def connection
      @connection ||= Faraday.new(url: Marqeta.configuration.base_url) do |faraday|
        faraday.request :url_encoded
        faraday.response :logger, Marqeta.configuration.logger
        faraday.adapter Faraday.default_adapter
      end
    end

    def endpoint_with_params
      return endpoint if params.empty?

      query = URI.encode_www_form(params)
      "#{endpoint}?#{query}"
    end

    def parse_response(response)
      JSON.parse(response.body)
    end

    def log_request_and_response(method, response)
      Marqeta.configuration.logger.info("Request: #{method.upcase} #{endpoint_with_params}")
      Marqeta.configuration.logger.info("Response: #{response.status} #{response.body}")
    end
  end
end
