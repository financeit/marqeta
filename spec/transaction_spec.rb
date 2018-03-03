require 'spec_helper'

describe Marqeta::Transaction do
  describe 'class methods' do
    describe '.since' do
      let(:since) { Marqeta::Transaction.since(start_time) }
      let(:start_time) { Time.new(2018, 1, 1, 0, 0, 0, '-05:00') }

      before do
        allow_any_instance_of(Marqeta::ApiCaller)
          .to(receive(:get))
          .and_return(
            'data' => [
              {
                'token' => 'token1',
                'state' => Marqeta::Transaction::PENDING_STATE,
                'user_token' => 'user_token1',
                'amount' => 1000
              },
              {
                'token' => 'token2',
                'state' => 'DECLINED',
                'user_token' => 'user_token2',
                'amount' => 2000
              }
            ]
          )
      end

      it 'creates an ApiCaller with properly formatted endpoint' do
        params = {
          start_date: '2018-01-01T00:00:00.000-0500',
          type: 'authorization',
          state: 'ALL'
        }

        expect(Marqeta::ApiCaller)
          .to(receive(:new))
          .with('transactions', params)
          .and_call_original

        since
      end

      it 'calls get on an ApiCaller' do
        expect_any_instance_of(Marqeta::ApiCaller).to(receive(:get))
        since
      end

      it 'returns expected Tranaction objects' do
        transactions = since
        expect(transactions.length).to eq(2)
        expect(transactions.map(&:class).uniq).to eq([Marqeta::Transaction])
        expect(transactions.map(&:token)).to eq(%w[token1 token2])
        expect(transactions.map(&:state)).to eq(%w[PENDING DECLINED])
        expect(transactions.map(&:user_token)).to eq(%w[user_token1 user_token2])
        expect(transactions.map(&:amount)).to eq([1000, 2000])
      end
    end
  end

  describe 'instance methods' do
    subject(:transaction) { Marqeta::Transaction.new(state: state) }
    let(:state) { Marqeta::Transaction::PENDING_STATE }

    describe '#pending?' do
      let(:pending?) { transaction.pending? }

      context 'if state is pending state' do
        it 'returns true' do
          expect(pending?).to eq(true)
        end
      end

      context 'if state is not pending state' do
        let(:state) { 'DECLINED' }

        it 'returns false' do
          expect(pending?).to eq(false)
        end
      end
    end
  end
end
