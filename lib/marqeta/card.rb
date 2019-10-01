# typed: true
require 'marqeta/api_object'
require 'marqeta/client_access'

module Marqeta
  class Card < ApiObject
    extend T::Sig

    ACTIVE_STATE = T.let('ACTIVE'.freeze, String)

    sig {returns(String)}
    def self.endpoint
      'cards'
    end

    sig {params(pan: String).returns(Marqeta::Card)}
    def self.from_pan(pan)
      result = ApiCaller.new('cards/getbypan').post(pan: pan)
      new(token: result['card_token'])
    end

    sig {returns(T::Boolean)}
    def active?
      state == ACTIVE_STATE && Time.now < expiration_time
    end

    sig {returns(T::Boolean)}
    def pin_is_set?
      pin_is_set
    end

    sig {params(show_cvv_number: T::Boolean).void}
    def show_pan(show_cvv_number: false)
      self.attributes_hash = ApiCaller.new("cards/#{token}/showpan", show_cvv_number: show_cvv_number).get
    end

    sig {returns(Marqeta::ApiObject)}
    def create_client_access
      ClientAccess.api_create(card_token: token)
    end

    sig {returns(Time)}
    def expiration_time
      Time.parse(symbolized_attributes_hash[:expiration_time])
    end

    sig { returns(String) }
    def state
      symbolized_attributes_hash[:state]
    end

    sig { returns(String) }
    def pan
      symbolized_attributes_hash[:pan]
    end

    sig { returns(String) }
    def user_token
      symbolized_attributes_hash[:user_token]
    end

    sig { returns(String) }
    def card_product_token
      symbolized_attributes_hash[:card_product_token]
    end

    sig { returns(String) }
    def fulfillment_status
      symbolized_attributes_hash[:fulfillment_status]
    end

    sig { returns(Integer) }
    def cvv_number
      symbolized_attributes_hash[:cvv_number]
    end

    sig { returns(String) }
    def expiration
      symbolized_attributes_hash[:expiration]
    end

    sig { returns(T::Boolean) }
    def pin_is_set
      symbolized_attributes_hash[:pin_is_set]
    end

    sig { returns(Integer) }
    def last_four
      symbolized_attributes_hash[:last_four]
    end
  end
end
