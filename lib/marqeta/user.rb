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

    def create_child
      self.class.api_create(uses_parent_account: true, parent_token: token)
    end

    def children
      ApiObject.object_list(User, "users/#{token}/children")
    end
  end
end
