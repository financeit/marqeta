module Marqeta
  class Transaction < ApiObject

    PENDING_STATE = 'PENDING'.freeze

    def self.endpoint
      'simulate/authorization'
    end

    def self.since(start_time)
      params_string = URI.encode_www_form(
        start_date: start_time.strftime('%Y-%m-%dT%H:%M:%S.%L%z'),
        type: 'authorization',
        state: 'ALL'
      )
      result = ApiCaller.new("transactions?#{params_string}").get
      result['data'].map{|transaction_hash| new(transaction_hash)}
    end

    def amount
      attributes_hash['amount']
    end

    def pending?
      state == PENDING_STATE
    end

    private

    def accessible_attributes
      super + %i(state user_token amount)
    end
  end
end
