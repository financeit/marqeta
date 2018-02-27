require 'spec_helper'

describe Marqeta::ApiCaller do
  subject(:api_caller) { Marqeta::ApiCaller.new(endpoint) }
  let(:endpoint) { 'foo' }
  let(:response_hash) { { 'a' => 1, 'b' => 2 } }

  describe '#get' do
    let(:get) { api_caller.get }
    before do
      allow_any_instance_of(RestClient::Resource)
        .to(receive(:get))
        .and_return(response_hash.to_json)
    end

    it 'sends correct get request to the RestClient Resource' do
      expect_any_instance_of(RestClient::Resource).to receive(:get)
      get
    end

    it 'returns parsed JSON response' do
      expect(get).to eq(response_hash)
    end

    it 'logs the request and response' do
      expect(Marqeta.configuration.logger).to(receive(:info)).twice
      get
    end
  end

  describe '#post' do
    let(:post) { api_caller.post(payload) }
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
      post
    end

    it 'returns parsed JSON response' do
      expect(post).to eq(response_hash)
    end

    it 'logs the request and response' do
      expect(Marqeta.configuration.logger).to(receive(:info)).twice
      post
    end
  end
end
