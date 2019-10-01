# typed: true
require 'marqeta/api_object'
require 'marqeta/client_access'

module Marqeta
  class Card < ApiObject
    ACTIVE_STATE = 'ACTIVE'.freeze

    def self.endpoint
      'cards'
    end

    def self.from_pan(pan)
      result = ApiCaller.new('cards/getbypan').post(pan: pan)
      new(token: result['card_token'])
    end

    def active?
      state == ACTIVE_STATE && Time.now < expiration_time
    end

    def pin_is_set?
      pin_is_set
    end

    def show_pan(show_cvv_number: false)
      self.attributes_hash = ApiCaller.new("cards/#{token}/showpan", show_cvv_number: show_cvv_number).get
    end

    def create_client_access
      ClientAccess.api_create(card_token: token)
    end

    def expiration_time
      Time.parse(symbolized_attributes_hash[:expiration_time])
    end

    def state
      symbolized_attributes_hash[:state]
    end

    def pan
      symbolized_attributes_hash[:pan]
    end

    def user_token
      symbolized_attributes_hash[:user_token]
    end

    def card_product_token
      symbolized_attributes_hash[:card_product_token]
    end

    def fulfillment_status
      symbolized_attributes_hash[:fulfillment_status]
    end

    def cvv_number
      symbolized_attributes_hash[:cvv_number]
    end

    def expiration
      symbolized_attributes_hash[:expiration]
    end

    def pin_is_set
      symbolized_attributes_hash[:pin_is_set]
    end

    def last_four
      symbolized_attributes_hash[:last_four]
    end
  end
end
