require 'spec_helper'

describe Marqeta::User do
  subject(:user) { Marqeta::User.new(token: user_token) }

  let(:user_token) { 'user_token' }

  describe 'card methods' do
    let(:active_token) { '12345' }
    let(:inactive_token) { '54321' }

    before do
      allow_any_instance_of(Marqeta::ApiCaller).to receive(:get).and_return(
        'data' => [
          { 'token' => active_token, 'state' => Marqeta::Card::ACTIVE_STATE },
          { 'token' => inactive_token, 'state' => 'inactive' }
        ]
      )
    end

    describe '#cards' do
      let(:cards) { user.cards }

      it 'contains the correct Marqeta::Card objects' do
        expect(cards.length).to eq(2)
        expect(cards.map(&:class).uniq).to eq([Marqeta::Card])
        expect(cards.map(&:token)).to eq([active_token, inactive_token])
      end
    end

    describe '#active_card' do
      let(:active_card) { user.active_card }

      it 'returns card with active state' do
        expect(active_card.token).to eq(active_token)
      end
    end
  end
end
