module Marqeta
  class ApiObject

    def initialize(attributes_hash)
      self.attributes_hash = attributes_hash
    end

    def self.api_create(payload = {})
      new(ApiCaller.new(endpoint).post(payload))
    end

    def self.endpoint
      raise 'must be implemented in subclass'
    end

    def method_missing(method_name, *args, &block)
      if respond_to_missing?(method_name)
        attributes_hash.symbolize_keys[method_name]
      else
        super
      end
    end

    def respond_to_missing?(method_name, include_private = false)
      method_name.in?(accessible_attributes) || super
    end

    private

    attr_accessor :attributes_hash

    def accessible_attributes
      %i(token)
    end

  end
end
