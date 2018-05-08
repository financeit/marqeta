module Marqeta
  class User < ApiObject
    def self.endpoint
      'users'
    end

    def cards
      ApiObject.object_list(Card, "cards/user/#{token}")
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

    def metadata_attribute(key)
      metadata = symbolized_attributes_hash[:metadata]
      return nil if metadata.nil?
      metadata[key.to_s]
    end

    private

    def accessible_time_attributes
      %i[created_time]
    end
  end
end
