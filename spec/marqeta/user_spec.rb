describe Marqeta::User do
  subject(:user) { Marqeta::User.new(token: user_token, metadata: metadata) }

  let(:user_token) { 'user_token' }
  let(:metadata) { nil }

  describe '#cards' do
    it 'calls object_list method with expected params' do
      expect(Marqeta::ApiObject).to receive(:object_list).with(Marqeta::Card, "cards/user/#{user_token}")
      user.cards
    end
  end

  describe '#children' do
    it 'calls object_list method with expected params' do
      expect(Marqeta::ApiObject).to receive(:object_list).with(Marqeta::User, "users/#{user_token}/children")
      user.children
    end
  end

  describe '#create_child' do
    it "creates a User resource passing in the user's token and uses_parent_account: true" do
      expect(Marqeta::User).to receive(:api_create).with(parent_token: user_token, uses_parent_account: false)
      user.create_child
    end

    it 'allows passing in extra parameters' do
      extra_params = { foo: 'bar' }
      expect(Marqeta::User).to receive(:api_create).with(
        parent_token: user_token,
        uses_parent_account: false,
        foo: 'bar'
      )
      user.create_child(extra_params)
    end
  end

  describe '#create_onetime' do
    it "creates a OneTime resource passing in the user's token" do
      expect(Marqeta::OneTime).to receive(:api_create).with(user_token: user_token)
      user.create_onetime
    end
  end

  describe '#perform_kyc' do
    it "creates a Kyc resource passing in the user's token" do
      expect(Marqeta::Kyc).to receive(:api_create).with(user_token: user_token)
      user.perform_kyc
    end

    it 'allows passing in extra parameters' do
      extra_params = { manual_override: true }
      expect(Marqeta::Kyc).to receive(:api_create).with(user_token: user_token, manual_override: true)
      user.perform_kyc(extra_params)
    end
  end

  describe '#metadata_attribute' do
    it 'returns nil if there is no metadata' do
      expect(user.metadata_attribute(:foo)).to eq(nil)
    end

    context 'when metadata is present' do
      let(:metadata) { { 'foo' => 'bar' } }

      it 'returns correct metadata attribute value if present' do
        expect(user.metadata_attribute(:foo)).to eq('bar')
      end

      it 'returns nil if metadata attribute is not present' do
        expect(user.metadata_attribute(:baz)).to eq(nil)
      end
    end
  end
end
