module Marqeta
  class User < ApiObject
    def self.endpoint
      'users'
    end

    def cards
      ApiObject.object_list(Card, "cards/user/#{token}")
    end

    def active_card
      cards.detect(&:active?)
    end

    def perform_kyc(extra_params = {})
      Kyc.api_create(extra_params.merge(user_token: token))
    end

    def create_child(extra_params = {})
      self.class.api_create(extra_params.merge(uses_parent_account: true, parent_token: token))
    end

    def children
      ApiObject.object_list(User, "users/#{token}/children")
    end
  end
end
