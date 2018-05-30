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

    def show_pan(show_cvv_number: false)
      self.attributes_hash = ApiCaller.new("cards/#{token}/showpan", show_cvv_number: show_cvv_number).get
    end

    def create_client_access
      ClientAccess.api_create(card_token: token)
    end

    private

    def accessible_attributes
      super + %i[state pan card_product_token fulfillment_status cvv_number expiration]
    end

    def accessible_time_attributes
      %i[expiration_time]
    end
  end
end
