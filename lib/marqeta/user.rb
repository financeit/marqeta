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

    def gpa_balance
      response = ApiCaller.new("balances/#{token}").get
      GpaBalance.new(response['gpa'])
    end
  end
end
