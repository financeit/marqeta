require 'marqeta/api_caller'
require 'marqeta/api_object'
require 'marqeta/gateway_response_codes'
require 'marqeta/transaction_response_codes'

module Marqeta
  class Transaction < ApiObject
    PENDING_STATE = 'PENDING'.freeze
    DECLINED_STATE = 'DECLINED'.freeze

    FORCE_CAPTURE_METHOD = 'pgfs.force_capture'.freeze

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
      payload[:webhook] = webhook if webhook_configured?

      ApiCaller.new('simulate/authorization').post(payload)
    end

    def self.simulate_reversal(payload)
      payload[:webhook] = webhook if webhook_configured?

      ApiCaller.new('simulate/reversal').post(payload)
    end

    def self.simulate_clearing(payload)
      payload[:is_refund] = false
      payload[:webhook] = webhook if webhook_configured?
      ApiCaller.new('simulate/clearing').post(payload)
    end

    def self.simulate_refund(payload)
      payload[:is_refund] = true
      payload[:webhook] = webhook if webhook_configured?
      ApiCaller.new('simulate/clearing').post(payload)
    end

    def self.webhook
      {
        endpoint: Marqeta.configuration.webhook_endpoint,
        username: Marqeta.configuration.webhook_username,
        password: Marqeta.configuration.webhook_password
      }
    end

    def self.webhook_configured?
      !Marqeta.configuration.webhook_endpoint.nil?
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

    def gateway_duration
      log = gateway_log
      log.fetch('duration') unless log.nil?
    end

    def gateway_response_memo
      log = gateway_log
      log.fetch('message') unless log.nil?
    end

    def response_memo
      attributes_hash.fetch('response').fetch('memo')
    end

    def card_acceptor
      CardAcceptor.new(card_acceptor_hash['name'])
    end

    def channel
      # channel field is not always sent in transaction
      poi_hash['channel']
    end

    def force_capture?
      method == FORCE_CAPTURE_METHOD
    end

    private

    def accessible_attributes
      super + %i[state user_token card_token amount preceding_related_transaction_token]
    end

    def card_acceptor_hash
      attributes_hash['card_acceptor']
    end

    def poi_hash
      card_acceptor_hash.fetch('poi')
    end

    def gateway_log
      attributes_hash['gpa_order']['funding']['gateway_log']
    rescue NoMethodError # Marqeta may send us only a portion of the above fetch (no documentation for the behaviour)
      nil
    end

    def gateway_response_code
      log = gateway_log
      log.fetch('response').fetch('code') unless log.nil?
    end

    def response_code
      attributes_hash.fetch('response').fetch('code')
    end

    def method
      attributes_hash['gpa_order']['jit_funding']['method']
    rescue NoMethodError
      nil
    end
  end
end
