require 'json'
require 'rest-client'

module Marqeta
  class ApiCaller
    def initialize(endpoint)
      @endpoint = endpoint
    end

    def get
      logger.info("GET: #{endpoint}")
      response_hash = JSON.parse(resource.get)
      logger.info("Response: #{response_hash.to_json}")
      response_hash
    end

    def post(payload)
      json_payload = payload.to_json
      logger.info "POST: #{endpoint}, #{json_payload}"
      response_hash = JSON.parse(
        resource.post(json_payload, content_type: 'application/json')
      )
      logger.info("Response: #{response_hash.to_json}")
      response_hash
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
