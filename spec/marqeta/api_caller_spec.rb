describe Marqeta::ApiCaller do
  subject(:api_caller) { Marqeta::ApiCaller.new(endpoint, params) }

  let(:endpoint) { 'foo' }
  let(:params) { {} }
  let(:response_hash) { { 'a' => 1, 'b' => 2 } }

  describe 'initializer' do
    let(:final_endpoint) { api_caller.send(:endpoint) }

    it 'sets final endpoint as regular endpoint if no params' do
      expect(final_endpoint).to eq(endpoint)
    end

    context 'params are passed in' do
      let(:params) { { foo: 'bar', biz: 'biz:baz' } }

      it 'sets final endpoint to have the params URI encoded' do
        expect(final_endpoint).to eq("#{endpoint}?foo=bar&biz=biz%3Abaz")
      end
    end
  end

  describe '#get' do
    let(:resource) { instance_double(RestClient::Resource) }

    before do
      allow(RestClient::Resource).to receive(:new).and_return(resource)
      allow(resource).to receive(:get).and_return(response_hash.to_json)
    end

    it 'sends correct get request to the RestClient Resource' do
      expect(resource).to receive(:get)
      api_caller.get
    end

    it 'returns parsed JSON response' do
      result = api_caller.get
      expect(result).to eq(response_hash)
    end

    it 'logs the request and response' do
      expect(Marqeta.configuration.logger).to(receive(:info)).twice
      api_caller.get
    end
  end

  describe '#post' do
    let(:payload) { { 'foo' => 'bar', 'biz' => 'baz' } }

    before do
      allow_any_instance_of(RestClient::Resource)
        .to(receive(:post))
        .and_return(response_hash.to_json)
    end

    it 'sends correct post request to the RestClient Resource' do
      expect_any_instance_of(RestClient::Resource)
        .to receive(:post)
        .with(payload.to_json, content_type: 'application/json')
      api_caller.post(payload)
    end

    it 'returns parsed JSON response' do
      result = api_caller.post(payload)
      expect(result).to eq(response_hash)
    end

    it 'logs the request and response' do
      expect(Marqeta.configuration.logger).to(receive(:info)).twice
      api_caller.post(payload)
    end
  end
end
