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

    # TODO: Move this to be set in gem initializer when we convert this to a gem
    # https://stackoverflow.com/questions/8693158/how-can-i-write-to-rails-logger-within-my-gem
    # https://github.com/restforce/restforce#loggingdebugginginstrumenting
    def logger
      return @@logger if defined?(@@logger)
      @@logger = Logger.new(Rails.root.join('log', 'marqeta.log'))
      @@logger.formatter = Logger::Formatter.new
      @@logger
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
  end
end
