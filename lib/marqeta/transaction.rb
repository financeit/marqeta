module Marqeta
  class Transaction < ApiObject
    PENDING_STATE = 'PENDING'.freeze

    CardAcceptor = Struct.new(:name)

    def self.endpoint
      'simulate/authorization'
    end

    def self.index(start_date: nil, user_token: nil)
      params = {
        type: 'authorization',
        state: 'ALL'
      }
      params[:start_date] = start_date.strftime('%Y-%m-%dT%H:%M:%S.%L%z') unless start_date.nil?
      params[:user_token] = user_token unless user_token.nil?

      result = ApiCaller.new('transactions', params).get
      result['data'].map { |transaction_hash| new(transaction_hash) }
    end

    def pending?
      state == PENDING_STATE
    end

    def card_acceptor
      CardAcceptor.new(card_acceptor_hash['name'])
    end

    private

    def accessible_attributes
      super + %i[state user_token amount created_time]
    end

    def card_acceptor_hash
      attributes_hash['card_acceptor']
    end
  end
end
