# frozen_string_literal: true

module Marqeta
  class HttpError < StandardError
    # From https://github.com/thoughtbot/suspenders/blob/master/templates/errors.rb
    ERROR_LIST = [
      EOFError,
      Errno::ECONNRESET,
      Errno::EINVAL,
      Net::HTTPBadResponse,
      Net::HTTPHeaderSyntaxError,
      Net::ProtocolError,
      Timeout::Error
    ].freeze
  end

  class ApiError < StandardError
    def initialize(response)
      @response = response
    end

    def http_code
      @response.code
    end

    def http_code_description
      RestClient::STATUSES[http_code]
    end

    def error_code
      response_hash['error_code']
    end

    def error_message
      response_hash['error_message']
    end

    def to_s
      "#{http_code} #{http_code_description}: #{error_code} #{error_message}"
    end

    private

    def response_hash
      @response_hash ||= JSON.parse(@response)
    end
  end
end
