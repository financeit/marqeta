require 'marqeta/api_caller'
require 'time'

module Marqeta
  class ApiObject
    QUERY_RESULTS_COUNT = 100

    def initialize(attributes_hash)
      self.attributes_hash = attributes_hash
    end

    def self.api_create(payload = {}, params = {})
      new(ApiCaller.new(endpoint, params).post(payload))
    end

    def self.api_retrieve(token)
      new(ApiCaller.new("#{endpoint}/#{token}").get)
    end

    def self.api_update(token, payload = {})
      new(ApiCaller.new("#{endpoint}/#{token}").put(payload))
    end

    def self.endpoint
      raise 'must be implemented in subclass'
    end

    def self.object_list(klass, endpoint)
      results = []
      start_index = 0
      is_more = true

      while is_more
        paginated_params = {
          count: QUERY_RESULTS_COUNT,
          start_index:
        }
        paginated_endpoint = "#{endpoint}?#{URI.encode_www_form(paginated_params)}"
        response = ApiCaller.new(paginated_endpoint).get
        results += response['data']
        start_index += QUERY_RESULTS_COUNT
        is_more = response['is_more']
      end

      results.map { |data_hash| klass.new(data_hash) }
    end

    def method_missing(method_name, *args, &block)
      if respond_to_missing?(method_name)
        attribute_value(method_name)
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
      [:token] + accessible_time_attributes
    end

    def accessible_time_attributes
      %i[created_time]
    end

    def symbolized_attributes_hash
      new_array = []
      attributes_hash.each { |k, v| new_array << [k.to_sym, v] }
      Hash[new_array]
    end

    def attribute_value(attribute)
      value = symbolized_attributes_hash[attribute]
      value = Time.parse(value) if accessible_time_attributes.include?(attribute)
      value
    end
  end
end
