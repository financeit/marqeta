module Marqeta
  class Card < ApiObject

    ACTIVE_STATE = 'ACTIVE'.freeze

    def self.endpoint
      'cards'
    end

    def self.from_pan(pan)
      result = ApiCaller.new("cards/getbypan").post(pan: pan)
      new(token: result['card_token'])
    end

    def active?
      state == ACTIVE_STATE
    end

    def retrieve_pan
      self.attributes_hash = ApiCaller.new("cards/#{token}/showpan").get
    end

    private

    def accessible_attributes
      super + %i(state pan expiration_time)
    end
  end
end
