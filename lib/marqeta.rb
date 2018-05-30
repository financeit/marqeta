require 'marqeta/api_caller'
require 'marqeta/api_object'
require 'marqeta/card'
require 'marqeta/card_product'
require 'marqeta/client_access'
require 'marqeta/errors'
require 'marqeta/kyc'
require 'marqeta/one_time'
require 'marqeta/transaction'
require 'marqeta/user'
require 'marqeta/version'

module Marqeta
  class Configuration
    attr_accessor :username, :password, :base_url, :logger
  end

  class << self
    def configure
      yield(configuration)
      configuration
    end

    def configuration
      @_configuration ||= Configuration.new
    end
  end
end
