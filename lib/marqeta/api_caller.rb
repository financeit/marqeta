require 'json'
require 'rest-client'

module Marqeta
  class ApiCaller
    def initialize(endpoint, params = {})
      @endpoint = endpoint
      @endpoint += "?#{URI.encode_www_form(params)}" if params.any?
    end

    def get
      logger.info("GET: #{endpoint}")
      response = resource.get
      logger.info("Response: #{response}")
      JSON.parse(response)
    end

    def post(payload)
      json_payload = payload.to_json
      logger.info "POST: #{endpoint}, #{json_payload}"
      response = resource.post(json_payload, content_type: 'application/json')
      logger.info("Response: #{response}")
      JSON.parse(response)
    end

    private

    attr_reader :endpoint

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
  end
end
