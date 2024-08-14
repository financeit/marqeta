# frozen_string_literal: true

require 'marqeta/api_object'

module Marqeta
  class Kyc < ApiObject
    def self.endpoint
      'kyc'
    end
  end
end
