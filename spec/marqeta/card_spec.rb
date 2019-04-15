describe Marqeta::Card do
  let(:pan) { '1234567890' }
  let(:card_token) { 'CARD_TOKEN' }

  describe 'class methods' do
    describe '.from_pan' do
      before do
        allow_any_instance_of(Marqeta::ApiCaller)
          .to(receive(:post))
          .and_return('card_token' => card_token)
      end

      it 'creates an ApiCaller with the getbypan endpoint' do
        expect(Marqeta::ApiCaller)
          .to(receive(:new))
          .with('cards/getbypan')
          .and_call_original
        Marqeta::Card.from_pan(pan)
      end

      it 'posts the pan to an ApiCaller' do
        api_caller = instance_double(Marqeta::ApiCaller)
        allow(Marqeta::ApiCaller).to receive(:new).and_return(api_caller)
        expect(api_caller).to receive(:post).with(pan: pan).and_return({})

        Marqeta::Card.from_pan(pan)
      end

      it 'returns a Card with token set correctly' do
        card = Marqeta::Card.from_pan(pan)
        expect(card).to be_a(Marqeta::Card)
        expect(card.token).to eq(card_token)
      end
    end
  end

  describe 'instance methods' do
    subject(:card) do
      Marqeta::Card.new(
        token: card_token,
        state: state,
        pin_is_set: pin_is_set,
        expiration_time: expiration_time
      )
    end

    let(:state) { Marqeta::Card::ACTIVE_STATE }
    let(:pin_is_set) { true }
    let(:expiration_time) { not_expired_time }
    let(:not_expired_time) { (Time.now + 3600).to_s }

    describe '#active?' do
      let(:active?) { card.active? }
      let(:expired_time) { (Time.now - 3600).to_s }
      let(:inactive_state) { 'inactive' }

      context "when card state is 'active' and card has not expired" do
        it 'returns true' do
          expect(active?).to be(true)
        end
      end

      context "when card state is 'active' and card has expired" do
        let(:expiration_time) { expired_time }

        it 'returns false' do
          expect(active?).to be(false)
        end
      end

      context "when card state is something other than 'active' and card has not expired" do
        let(:state) { inactive_state }

        it 'returns false' do
          expect(active?).to be(false)
        end
      end

      context "when card state is something other than 'active' and card has expired" do
        let(:state) { inactive_state }
        let(:expiration_time) { expired_time }

        it 'returns false' do
          expect(active?).to be(false)
        end
      end
    end

    describe '#pin_is_set?' do
      context "when card pin is set" do
        it 'returns true' do
          expect(card.pin_is_set?).to be(true)
        end
      end

      context "when card pin is not set" do
        let(:pin_is_set) { false }

        it 'returns false' do
          expect(card.pin_is_set?).to be(false)
        end
      end
    end

    describe '#show_pan' do
      before do
        allow_any_instance_of(Marqeta::ApiCaller)
          .to(receive(:get))
          .and_return('token' => card_token, 'pan' => pan)
      end

      it 'creates an ApiCaller with the showpan endpoint' do
        expect(Marqeta::ApiCaller)
          .to(receive(:new))
          .with("cards/#{card_token}/showpan", show_cvv_number: false)
          .and_call_original
        card.show_pan
      end

      it 'passes is show_cvv_number as true is specifies' do
        expect(Marqeta::ApiCaller)
          .to(receive(:new))
          .with("cards/#{card_token}/showpan", show_cvv_number: true)
          .and_call_original
        card.show_pan(show_cvv_number: true)
      end

      it 'calls get on an ApiCaller' do
        expect_any_instance_of(Marqeta::ApiCaller).to(receive(:get))
        card.show_pan
      end

      it 'sets attributes to showpan response' do
        card.show_pan
        expect(card.token).to eq(card_token)
        expect(card.pan).to eq(pan)
      end
    end

    describe '#create_client_access' do
      it "creates a ClientAccess resource passing in the card's token" do
        expect(Marqeta::ClientAccess).to receive(:api_create).with(card_token: card_token)
        card.create_client_access
      end
    end
  end
end
