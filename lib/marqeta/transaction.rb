module Marqeta
  class Transaction < ApiObject
    PENDING_STATE = 'PENDING'.freeze
    DECLINED_STATE = 'DECLINED'.freeze

    CardAcceptor = Struct.new(:name)

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

    def self.simulate_authorization(payload)
      ApiCaller.new('simulate/authorization').post(payload)
    end

    def self.simulate_reversal(payload)
      ApiCaller.new('simulate/reversal').post(payload)
    end

    def self.simulate_clearing(payload)
      payload[:is_refund] = false
      ApiCaller.new('simulate/clearing').post(payload)
    end

    def self.simulate_refund(payload)
      payload[:is_refund] = true
      ApiCaller.new('simulate/clearing').post(payload)
    end

    def pending?
      state == PENDING_STATE
    end

    def declined?
      state == DECLINED_STATE
    end

    def declined_by_jit?
      declined? && gateway_response_code == GatewayResponseCodes::DECLINED_BY_JIT
    end

    def timeout?
      gateway_response_code == GatewayResponseCodes::TIMEOUT
    end

    def jit_error?
      gateway_response_code == GatewayResponseCodes::JIT_ERROR
    end

    def exceeding_amount_limit?
      response_code == TransactionResponseCodes::EXCEEDING_AMOUNT_LIMIT
    end

    def exceeding_count_limit?
      response_code == TransactionResponseCodes::EXCEEDING_COUNT_LIMIT
    end

    def card_acceptor
      CardAcceptor.new(card_acceptor_hash['name'])
    end

    private

    def accessible_attributes
      super + %i[state user_token amount preceding_related_transaction_token]
    end

    def accessible_time_attributes
      %i[created_time]
    end

    def card_acceptor_hash
      attributes_hash['card_acceptor']
    end

    def gateway_response_code
      attributes_hash['gpa_order']['funding']['gateway_log']['response']['code']
    rescue NoMethodError # Marqeta may send us only a portion of the above fetch (no documentation for the behaviour)
      nil
    end

    def response_code
      attributes_hash.fetch('response').fetch('code')
    end
  end
end
