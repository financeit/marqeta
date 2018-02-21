require 'marqeta/api_caller'
require 'marqeta/api_object'
require 'marqeta/card'
require 'marqeta/card_product'
require 'marqeta/funding_source'
require 'marqeta/gpa_balance'
require 'marqeta/gpa_order'
require 'marqeta/transaction'
require 'marqeta/user'
require 'marqeta/version'

module Marqeta
  class Configuration
    attr_accessor :username, :password, :base_url,
                  :transaction_username, :transaction_password,
                  :virtual_card_product_token, :funding_source_token
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
