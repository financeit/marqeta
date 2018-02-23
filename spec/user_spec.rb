require 'spec_helper'

describe Marqeta::User do
  subject(:user) { Marqeta::User.new(token: user_token) }
  let(:user_token) { 'user token' }

  describe '#cards' do
    let(:cards) { user.cards }

    before do
      Marqeta::ApiCaller.any_instance.stub(:get).and_return(
        'data' => [
          { 'token' => '12345' },
          { 'token' => '54321' }
        ]
      )
    end

    it 'contains the correct number of Marqeta::Card objects' do
      expect(cards.length).to eq(2)
      cards.each do |card|
        expect(card.class).to eq(Marqeta::Card)
      end
    end
  end
end
