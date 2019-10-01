require 'marqeta/api_caller'

module Marqeta
  class ApiObject
    QUERY_RESULTS_COUNT = 100

    def initialize(attributes_hash)
      self.attributes_hash = attributes_hash
    end

    def self.api_create(payload = {})
      new(ApiCaller.new(endpoint).post(payload))
    end

    def self.api_retrieve(token)
      new(ApiCaller.new("#{endpoint}/#{token}").get)
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
          start_index: start_index
        }
        paginated_endpoint = "#{endpoint}?#{URI.encode_www_form(paginated_params)}"
        response = ApiCaller.new(paginated_endpoint).get
        results += response['data']
        start_index += QUERY_RESULTS_COUNT
        is_more = response['is_more']
      end

      results.map { |data_hash| klass.new(data_hash) }
    end

    def token
      symbolized_attributes_hash[:token]
    end

    def created_time
      Time.parse(symbolized_attributes_hash[:created_time])
    end

    private

    attr_accessor :attributes_hash

    def symbolized_attributes_hash
      Hash[attributes_hash.map { |k, v| [k.to_sym, v] }]
    end
  end
end
