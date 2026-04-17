# frozen_string_literal: true

require 'marqeta/api_object'

module Marqeta
  class CardTransition < ApiObject
    def self.endpoint
      'cardtransitions'
    end
  end
end
