module Marqeta
  class Webhook < ApiObject
    def self.endpoint
      'webhooks'
    end

    def create(params = {})
      self.class.api_create(params)
    end
    
    private
  end
end