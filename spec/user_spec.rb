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

      it 'contains the correct number of Marqeta::Card objects' do
        expect(cards.length).to eq(2)
        cards.each do |card|
          expect(card.class).to eq(Marqeta::Card)
        end
      end

      it 'has expected tokens' do
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

  describe '#gpa_balance' do
    let(:gpa_balance) { user.gpa_balance }

    before do
      allow_any_instance_of(Marqeta::ApiCaller).to receive(:get).and_return(
        'gpa' => {
          'ledger_balance' => 1000,
          'available_balance' => 2000
        }
      )
    end

    it 'returns Marqeta::GpaBalance object with expected balances' do
      expect(gpa_balance.class).to eq(Marqeta::GpaBalance)
      expect(gpa_balance.ledger_balance).to eq(1000)
      expect(gpa_balance.available_balance).to eq(2000)
    end
  end
end
