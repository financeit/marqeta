module Marqeta
  class Transaction < ApiObject
    PENDING_STATE = 'PENDING'.freeze

    def self.endpoint
      'simulate/authorization'
    end

    def self.index(params)
      result = ApiCaller.new('transactions', params).get
      result['data'].map { |transaction_hash| new(transaction_hash) }
    end

    def pending?
      state == PENDING_STATE
    end

    private

    def accessible_attributes
      super + %i[state user_token amount created_time card_acceptor]
    end
  end
end
