require 'marqeta/api_object'

module Marqeta
  class OneTime < ApiObject
    def self.endpoint
      'users/auth/onetime'
    end
  end
end
