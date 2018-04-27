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

    def self.object_list(klass, endpoint)
      response = ApiCaller.new(endpoint).get
      response['data'].map { |data_hash| klass.new(data_hash) }
    end

    def method_missing(method_name, *args, &block)
      if respond_to_missing?(method_name)
        symbolized_attributes_hash[method_name]
      else
        super
      end
    end

    def respond_to_missing?(method_name, include_private = false)
      accessible_attributes.include?(method_name) || super
    end

    private

    attr_accessor :attributes_hash

    def accessible_attributes
      [:token]
    end

    def symbolized_attributes_hash
      Hash[attributes_hash.map { |k, v| [k.to_sym, v] }]
    end
  end
end
