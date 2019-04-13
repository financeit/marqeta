require 'marqeta/api_object'

module Marqeta
  class ClientAccess < ApiObject
    def self.endpoint
      'users/auth/clientaccesstoken'
    end
  end
end
