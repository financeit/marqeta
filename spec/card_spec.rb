require 'spec_helper'

describe Marqeta::Card do
  subject(:card) { Marqeta::Card.new(token: token, state: state) }
  let(:token) { 'token' }
  let(:state) { Marqeta::Card::ACTIVE_STATE }

  describe '#active?' do
    let(:active?) { card.active? }

    it 'returns true if state is active state' do
      expect(active?).to eq(true)
    end

    it 'returns false if state is not active state' do
      allow(card).to receive(:state).and_return('inactive')
      expect(active?).to eq(false)
    end
  end
end
