# frozen_string_literal: true

describe Marqeta::ApiCaller do
  subject(:api_caller) { Marqeta::ApiCaller.new(endpoint, params) }

  let(:endpoint) { '/foo' }
  let(:params) { {} }
  let(:response_hash) { { 'a' => 1, 'b' => 2 } }
  let(:connection) { instance_double(Faraday::Connection) }
  let(:response) { instance_double(Faraday::Response, body: response_hash.to_json, status: 200) }

  before do
    allow(Faraday).to receive(:new).and_return(connection)
  end

  describe 'initializer' do
    let(:final_endpoint) { api_caller.send(:endpoint_with_params) }

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
    before do
      allow(connection).to receive(:get).and_return(response)
    end

    it 'sends correct get request to the Faraday connection' do
      expect(connection).to receive(:get).with(endpoint)
      api_caller.get
    end

    it 'returns parsed JSON response' do
      result = api_caller.get
      expect(result).to eq(response_hash)
    end

    it 'logs the request and response' do
      expect(Marqeta.configuration.logger).to receive(:info).twice
      api_caller.get
    end
  end

  describe '#post' do
    let(:payload) { { 'foo' => 'bar', 'biz' => 'baz' } }

    before do
      allow(connection).to receive(:post).and_return(response)
    end

    it 'sends correct post request to the Faraday connection' do
      expect(connection).to receive(:post).with(endpoint, payload.to_json, content_type: 'application/json')
      api_caller.post(payload)
    end

    it 'returns parsed JSON response' do
      result = api_caller.post(payload)
      expect(result).to eq(response_hash)
    end

    it 'logs the request and response' do
      expect(Marqeta.configuration.logger).to receive(:info).twice
      api_caller.post(payload)
    end
  end

  describe '#put' do
    let(:payload) { { 'foo' => 'bar', 'biz' => 'baz' } }

    before do
      allow(connection).to receive(:put).and_return(response)
    end

    it 'sends correct put request to the Faraday connection' do
      expect(connection).to receive(:put).with(endpoint, payload.to_json, content_type: 'application/json')
      api_caller.put(payload)
    end

    it 'returns parsed JSON response' do
      result = api_caller.put(payload)
      expect(result).to eq(response_hash)
    end

    it 'logs the request and response' do
      expect(Marqeta.configuration.logger).to receive(:info).twice
      api_caller.put(payload)
    end
  end
end
