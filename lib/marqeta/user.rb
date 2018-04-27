module Marqeta
  class User < ApiObject
    def self.endpoint
      'users'
    end

    def cards
      response = ApiCaller.new("cards/user/#{token}").get
      response['data'].map { |card_hash| Card.new(card_hash) }
    end

    def active_card
      cards.detect(&:active?)
    end
  end
end
