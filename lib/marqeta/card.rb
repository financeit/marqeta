require 'marqeta/api_object'
require 'marqeta/client_access'
require 'marqeta/card_transition'

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

    def terminate
      CardTransition.api_create(
        card_token: token,
        state: 'TERMINATED',
        channel: 'API',
        reason_code: '10' # Card was reported lost
      )
    end

    private

    def accessible_attributes
      super + %i[state pan user_token card_product_token fulfillment_status cvv_number expiration pin_is_set last_four]
    end

    def accessible_time_attributes
      super + %i[expiration_time]
    end
  end
end
