module Marqeta
  class Transaction < ApiObject
    PENDING_STATE = 'PENDING'.freeze
    DECLINED_STATE = 'DECLINED'.freeze

    EXCEEDING_LIMIT_MESSAGE = 'Exceeds withdrawal amount limit'.freeze
    TIMEOUT_MESSAGE = 'Operation timeout'.freeze
    JIT_ERROR_MESSAGE = 'Got 500 status code from gateway.'.freeze
    DECLINED_BY_JIT_MESSAGE = 'Declined by gateway.'.freeze

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
      declined? && gateway_log_message == DECLINED_BY_JIT_MESSAGE
    end

    def exceeding_limit?
      response_memo == EXCEEDING_LIMIT_MESSAGE
    end

    def timeout?
      gateway_log_message == TIMEOUT_MESSAGE
    end

    def jit_error?
      gateway_log_message == JIT_ERROR_MESSAGE
    end

    def card_acceptor
      CardAcceptor.new(card_acceptor_hash['name'])
    end

    def gateway_log_message
      attributes_hash['gpa_order']['funding']['gateway_log']['message'] if attributes_hash['gpa_order'].present?
    end

    def response_memo
      attributes_hash['response']['memo']
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
  end
end
