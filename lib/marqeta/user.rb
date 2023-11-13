require 'marqeta/api_object'

module Marqeta
  class User < ApiObject
    def self.endpoint
      'users'
    end

    def dashboard_url
      "#{Marqeta.configuration.dashboard_base_url}/program/user?token=#{token}"
    end

    def cards
      ApiObject.object_list(Card, "cards/user/#{token}")
    end

    def perform_kyc(extra_params = {})
      Kyc.api_create(extra_params.merge(user_token: token))
    end

    def create_child(extra_params = {})
      retrieved_self = self.class.api_retrieve(token)
      self.class.api_create(
        extra_params.merge(
          uses_parent_account: false,
          parent_token: token,
          first_name: retrieved_self.first_name,
          last_name: retrieved_self.last_name,
          address1: retrieved_self.address1,
          address2: retrieved_self.address2,
          city: retrieved_self.city,
          state: retrieved_self.state,
          zip: retrieved_self.zip,
          country: retrieved_self.country,
          birth_date: retrieved_self.birth_date,
        )
      )
    end

    def children
      ApiObject.object_list(User, "users/#{token}/children")
    end

    def create_onetime
      OneTime.api_create(user_token: token)
    end

    def metadata_attribute(key)
      metadata = symbolized_attributes_hash[:metadata]
      return nil if metadata.nil?
      metadata[key.to_s]
    end

    private

    def accessible_attributes
      super + %i[
        parent_token
        first_name
        last_name
        address1
        address2
        city
        state
        zip
        country
        birth_date
      ]
    end
  end
end
