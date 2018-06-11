require 'spec_helper'

describe Marqeta::Transaction do
  describe 'class methods' do
    describe '.index' do
      let(:start_date) { Time.new(2018, 1, 1, 0, 0, 0, '-05:00') }
      let(:user_token) { 'USER_TOKEN' }

      before do
        allow_any_instance_of(Marqeta::ApiCaller)
          .to(receive(:get))
          .and_return(
            'data' => [
              {
                'token' => 'token1',
                'state' => Marqeta::Transaction::PENDING_STATE,
                'user_token' => 'user_token1',
                'amount' => 1000,
                'created_time' => '2018-01-01T00:00:00Z',
                'card_acceptor' => {
                  'name' => 'Marqeta'
                }
              },
              {
                'token' => 'token2',
                'state' => 'DECLINED',
                'user_token' => 'user_token2',
                'amount' => 2000,
                'created_time' => '2018-01-02T00:00:00Z',
                'card_acceptor' => {
                  'name' => 'Financeit'
                }
              }
            ]
          )
      end

      it 'creates an ApiCaller with expected params' do
        expected_params = {
          type: 'authorization',
          state: 'ALL',
          start_date: '2018-01-01T00:00:00.000-0500',
          user_token: user_token
        }

        expect(Marqeta::ApiCaller)
          .to(receive(:new))
          .with('transactions', expected_params)
          .and_call_original

        fetch_transactions
      end

      it 'calls get on an ApiCaller' do
        expect_any_instance_of(Marqeta::ApiCaller).to(receive(:get))
        fetch_transactions
      end

      it 'returns expected Transaction objects' do
        transactions = fetch_transactions
        expect(transactions.length).to eq(2)
        expect(transactions.map(&:class).uniq).to eq([Marqeta::Transaction])
        expect(transactions.map(&:token)).to eq(%w[token1 token2])
        expect(transactions.map(&:state)).to eq(%w[PENDING DECLINED])
        expect(transactions.map(&:user_token)).to eq(%w[user_token1 user_token2])
        expect(transactions.map(&:amount)).to eq([1000, 2000])
        expect(transactions.map(&:created_time)).to eq([Time.parse('2018-01-01T00:00:00Z'), Time.parse('2018-01-02T00:00:00Z')])
        expect(transactions.map(&:card_acceptor).map(&:name)).to eq(%w[Marqeta Financeit])
      end

      def fetch_transactions
        Marqeta::Transaction.index(start_date: start_date, user_token: user_token)
      end
    end
  end

  describe 'instance methods' do
    subject(:transaction) { Marqeta::Transaction.new(state: state) }

    describe '#pending?' do
      context 'if state is pending state' do
        let(:state) { Marqeta::Transaction::PENDING_STATE }

        it 'returns true' do
          expect(transaction.pending?).to eq(true)
        end
      end

      context 'if state is not pending state' do
        let(:state) { 'RANDOM_STATE' }

        it 'returns false' do
          expect(transaction.pending?).to eq(false)
        end
      end
    end

    describe '#declined?' do
      context 'if state is declined state' do
        let(:state) { Marqeta::Transaction::DECLINED_STATE }

        it 'returns true' do
          expect(transaction.declined?).to eq(true)
        end
      end

      context 'if state is not declined state' do
        let(:state) { 'RANDOM_STATE' }

        it 'returns false' do
          expect(transaction.declined?).to eq(false)
        end
      end
    end
  end
end
