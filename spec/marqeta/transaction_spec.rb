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
        expect(transactions.map(&:created_time)).to eq([Time.parse('2018-01-01T00:00:00Z'),
                                                        Time.parse('2018-01-02T00:00:00Z')])
        expect(transactions.map(&:card_acceptor).map(&:name)).to eq(%w[Marqeta Financeit])
      end

      def fetch_transactions
        Marqeta::Transaction.index(start_date: start_date, user_token: user_token)
      end
    end

    describe '.simulate_authorization' do
      let(:endpoint) { 'simulate/authorization' }
      let(:payload) do
        {
          foo: 'bar'
        }
      end
      let(:api_caller) { instance_double(Marqeta::ApiCaller) }

      before do
        allow(Marqeta::ApiCaller).to(receive(:new)).with(endpoint).and_return(api_caller)
        allow(api_caller).to(receive(:post))
      end

      it 'creates ApiCaller with simulation endpoint' do
        expect(Marqeta::ApiCaller).to(receive(:new)).with(endpoint).and_return(api_caller)
        Marqeta::Transaction.simulate_authorization(payload)
      end

      it 'calls post on ApiCaller with payload' do
        expect(api_caller).to(receive(:post)).with(payload)
        Marqeta::Transaction.simulate_authorization(payload)
      end
    end

    describe '.simulate_reversal' do
      let(:endpoint) { 'simulate/reversal' }
      let(:payload) do
        {
          foo: 'bar'
        }
      end
      let(:api_caller) { instance_double(Marqeta::ApiCaller) }

      before do
        allow(Marqeta::ApiCaller).to(receive(:new)).with(endpoint).and_return(api_caller)
        allow(api_caller).to(receive(:post))
      end

      it 'creates ApiCaller with simulation endpoint' do
        expect(Marqeta::ApiCaller).to(receive(:new)).with(endpoint).and_return(api_caller)
        Marqeta::Transaction.simulate_reversal(payload)
      end

      it 'calls post on ApiCaller with payload' do
        expect(api_caller).to(receive(:post)).with(payload)
        Marqeta::Transaction.simulate_reversal(payload)
      end
    end

    describe '.simulate_clearing' do
      let(:endpoint) { 'simulate/clearing' }
      let(:payload) do
        {
          foo: 'bar'
        }
      end
      let(:clearing_payload) do
        {
          foo: 'bar',
          is_refund: false
        }
      end
      let(:api_caller) { instance_double(Marqeta::ApiCaller) }

      before do
        allow(Marqeta::ApiCaller).to(receive(:new)).with(endpoint).and_return(api_caller)
        allow(api_caller).to(receive(:post))
      end

      it 'creates ApiCaller with simulation endpoint' do
        expect(Marqeta::ApiCaller).to(receive(:new)).with(endpoint).and_return(api_caller)
        Marqeta::Transaction.simulate_clearing(payload)
      end

      it 'calls post on ApiCaller with payload' do
        expect(api_caller).to(receive(:post)).with(clearing_payload)
        Marqeta::Transaction.simulate_clearing(payload)
      end
    end

    describe '.simulate_refund' do
      let(:endpoint) { 'simulate/clearing' }
      let(:payload) do
        {
          foo: 'bar'
        }
      end
      let(:clearing_payload) do
        {
          foo: 'bar',
          is_refund: true
        }
      end
      let(:api_caller) { instance_double(Marqeta::ApiCaller) }

      before do
        allow(Marqeta::ApiCaller).to(receive(:new)).with(endpoint).and_return(api_caller)
        allow(api_caller).to(receive(:post))
      end

      it 'creates ApiCaller with simulation endpoint' do
        expect(Marqeta::ApiCaller).to(receive(:new)).with(endpoint).and_return(api_caller)
        Marqeta::Transaction.simulate_refund(payload)
      end

      it 'calls post on ApiCaller with payload' do
        expect(api_caller).to(receive(:post)).with(clearing_payload)
        Marqeta::Transaction.simulate_refund(payload)
      end
    end
  end

  describe 'instance methods' do
    subject(:transaction) do
      Marqeta::Transaction.new(
        'state' => state,
        'response' => {
          'memo' => response_memo,
          'code' => response_code
        },
        'gpa_order' => gpa_order,
        'card_acceptor' => {
          'poi' => poi
        }
      )
    end

    let(:gpa_order) do
      {
        'funding' => funding,
        'jit_funding' => jit_funding
      }
    end
    let(:funding) do
      {
        'gateway_log' => {
          'duration' => gateway_duration,
          'message' => gateway_response_memo,
          'response' => {
            'code' => gateway_response_code
          }
        }
      }
    end
    let(:jit_funding) do
      { 'method' => method }
    end
    let(:state) { 'RANDOM_STATE' }
    let(:gateway_duration) { 1000 }
    let(:gateway_response_memo) { "RANDOM_GATEWAY_RESPONSE_MEMO" }
    let(:gateway_response_code) { 'RANDOM_GATEWAY_RESPONSE_CODE' }
    let(:response_memo) { 'RANDOM_RESPONSE_MEMO' }
    let(:response_code) { 'RANDOM_RESPONSE_CODE' }
    let(:method) { 'RANDOM_METHOD' }

    let(:poi) do
      {}
    end

    describe '#pending?' do
      context 'when state is not pending state' do
        it 'returns false' do
          expect(transaction.pending?).to eq(false)
        end
      end

      context 'when state is pending state' do
        let(:state) { Marqeta::Transaction::PENDING_STATE }

        it 'returns true' do
          expect(transaction.pending?).to eq(true)
        end
      end
    end

    describe '#declined?' do
      context 'when state is not declined state' do
        it 'returns false' do
          expect(transaction.declined?).to eq(false)
        end
      end

      context 'when state is declined state' do
        let(:state) { Marqeta::Transaction::DECLINED_STATE }

        it 'returns true' do
          expect(transaction.declined?).to eq(true)
        end
      end
    end

    describe '#declined_by_jit?' do
      context 'when state is not declined and gateway_response_code is not DECLINED_BY_JIT' do
        it 'returns false' do
          expect(transaction.declined_by_jit?).to eq(false)
        end
      end

      context 'when state is declined and gateway_response_code is not DECLINED_BY_JIT' do
        let(:state) { Marqeta::Transaction::DECLINED_STATE }

        it 'returns false' do
          expect(transaction.declined_by_jit?).to eq(false)
        end
      end

      context 'when state is not declined and gateway_response_code is DECLINED_BY_JIT' do
        let(:gateway_response_code) { Marqeta::GatewayResponseCodes::DECLINED_BY_JIT }

        it 'returns false' do
          expect(transaction.declined_by_jit?).to eq(false)
        end
      end

      context 'when state is declined and gateway_response_code is DECLINED_BY_JIT' do
        let(:state) { Marqeta::Transaction::DECLINED_STATE }
        let(:gateway_response_code) { Marqeta::GatewayResponseCodes::DECLINED_BY_JIT }

        it 'returns true' do
          expect(transaction.declined_by_jit?).to eq(true)
        end
      end
    end

    describe '#timeout?' do
      context 'when gpa_order is nil' do
        let(:gpa_order) { nil }

        it 'returns false' do
          expect(transaction.timeout?).to eq(false)
        end
      end

      context 'when gpa_order is not nil and gateway_response_code is not TIMEOUT' do
        it 'returns false' do
          expect(transaction.timeout?).to eq(false)
        end
      end

      context 'when gpa_order is not nil and gateway_response_code is TIMEOUT' do
        let(:gateway_response_code) { Marqeta::GatewayResponseCodes::TIMEOUT }

        it 'returns true' do
          expect(transaction.timeout?).to eq(true)
        end
      end
    end

    describe '#jit_error?' do
      context 'when gpa_order is nil' do
        let(:gpa_order) { nil }

        it 'returns false' do
          expect(transaction.jit_error?).to eq(false)
        end
      end

      context 'when gpa_order is not nil and gateway_response_code is not JIT_ERROR' do
        it 'returns false' do
          expect(transaction.jit_error?).to eq(false)
        end
      end

      context 'when gpa_order is not nil and gateway_response_code is JIT_ERROR' do
        let(:gateway_response_code) { Marqeta::GatewayResponseCodes::JIT_ERROR }

        it 'returns true' do
          expect(transaction.jit_error?).to eq(true)
        end
      end
    end

    describe '#exceeding_amount_limit?' do
      context 'when response_code is not EXCEEDING_AMOUNT_LIMIT' do
        it 'returns false' do
          expect(transaction.exceeding_amount_limit?).to eq(false)
        end
      end

      context 'when response_code is EXCEEDING_AMOUNT_LIMIT' do
        let(:response_code) { Marqeta::TransactionResponseCodes::EXCEEDING_AMOUNT_LIMIT }

        it 'returns true' do
          expect(transaction.exceeding_amount_limit?).to eq(true)
        end
      end
    end

    describe '#exceeding_count_limit?' do
      context 'when response_code is not EXCEEDING_COUNT_LIMIT' do
        it 'returns false' do
          expect(transaction.exceeding_count_limit?).to eq(false)
        end
      end

      context 'when response_code is EXCEEDING_COUNT_LIMIT' do
        let(:response_code) { Marqeta::TransactionResponseCodes::EXCEEDING_COUNT_LIMIT }

        it 'returns true' do
          expect(transaction.exceeding_count_limit?).to eq(true)
        end
      end
    end

    describe '#gateway_duration' do
      context 'when gateway log is not present' do
        let(:gpa_order) do
          {
            'funding' => {}
          }
        end

        it 'returns nil' do
          expect(transaction.gateway_duration).to eq(nil)
        end
      end

      context 'when gateway log is present' do
        it 'returns the duration' do
          expect(transaction.gateway_duration).to eq(gateway_duration)
        end
      end
    end

    describe '#gateway_response_memo' do
      context 'when gateway log is not present' do
        let(:gpa_order) do
          {
            'funding' => {}
          }
        end

        it 'returns nil' do
          expect(transaction.gateway_response_memo).to eq(nil)
        end
      end

      context 'when gateway log is present' do
        it 'returns gateway response memo' do
          expect(transaction.gateway_response_memo).to eq(gateway_response_memo)
        end
      end
    end

    describe '#response_memo' do
      it 'returns response memo' do
        expect(transaction.response_memo).to eq(response_memo)
      end
    end

    describe '#channel' do
      context 'when the channel is not present' do
        it 'returns nil' do
          expect(transaction.channel).to eq(nil)
        end
      end

      context 'when the channel is present' do
        let(:poi) do
          {
            'channel' => 'RANDOM_CHANNEL'
          }
        end

        it 'returns the channel' do
          expect(transaction.channel).to eq('RANDOM_CHANNEL')
        end
      end
    end

    describe '#force_capture?' do
      context 'when method is not force capture' do
        it 'returns false' do
          expect(transaction.force_capture?).to eq(false)
        end
      end

      context 'when method is force capture' do
        let(:method) { 'pgfs.force_capture' }

        it 'returns true' do
          expect(transaction.force_capture?).to eq(true)
        end
      end

      context 'when jit_funding hash is not present' do
        let(:jit_funding) { nil }

        it 'returns false' do
          expect(transaction.force_capture?).to eq(false)
        end
      end
    end
  end
end
