module Marqeta
  class GpaBalance < ApiObject

    private

    def accessible_attributes
      super + %i(ledger_balance available_balance)
    end

  end
end
