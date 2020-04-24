require 'marqeta/api_object'

describe Marqeta::ApiObject do
  let(:endpoint) { 'foo' }

  before do
    allow(Marqeta::ApiObject)
      .to receive(:endpoint)
      .and_return(endpoint)
  end

  describe 'class methods' do
    describe '.api_create' do
      let(:payload) { { 'foo' => 'bar', 'biz' => 'baz' } }
      let(:response_hash) { { 'a' => 1, 'b' => 2 } }

      before do
        allow_any_instance_of(Marqeta::ApiCaller)
          .to(receive(:post))
          .and_return(response_hash)
      end

      it 'creates an ApiCaller with the endpoint' do
        expect(Marqeta::ApiCaller)
          .to(receive(:new))
          .with(endpoint)
          .and_call_original
        Marqeta::ApiObject.api_create(payload)
      end

      it 'posts the payload to an ApiCaller' do
        expect_any_instance_of(Marqeta::ApiCaller)
          .to(receive(:post))
          .with(payload)
        Marqeta::ApiObject.api_create(payload)
      end

      it 'creates and returns ApiObject with response sent to initializer' do
        expect(Marqeta::ApiObject)
          .to(receive(:new))
          .with(response_hash)
          .and_call_original
        result = Marqeta::ApiObject.api_create(payload)
        expect(result).to(be_a(Marqeta::ApiObject))
      end
    end

    describe '.api_retrieve' do
      let(:api_retrieve) { Marqeta::ApiObject.api_retrieve(token) }
      let(:token) { 'TOKEN' }
      let(:response_hash) { { 'a' => 1, 'b' => 2 } }

      before do
        allow_any_instance_of(Marqeta::ApiCaller)
          .to(receive(:get))
          .and_return(response_hash)
      end

      it 'creates an ApiCaller with the endpoint' do
        expect(Marqeta::ApiCaller)
          .to(receive(:new))
          .with(endpoint + '/' + token)
          .and_call_original
        api_retrieve
      end

      it 'calls get on the ApiCaller' do
        expect_any_instance_of(Marqeta::ApiCaller)
          .to(receive(:get))
        api_retrieve
      end

      it 'creates and returns ApiObject with response sent to initializer' do
        expect(Marqeta::ApiObject)
          .to(receive(:new))
          .with(response_hash)
          .and_call_original
        expect(api_retrieve).to(be_a(Marqeta::ApiObject))
      end
    end

    describe '.object_list' do
      let(:endpoint) { 'endpoint' }

      context 'when api returns no results' do
        let(:response_hash) { { 'data' => [], 'is_more' => false } }
        let(:paginated_endpoint) { "#{endpoint}?count=100&start_index=0" }
        let(:api_caller) { instance_double(Marqeta::ApiCaller) }

        before do
          allow(Marqeta::ApiCaller).to(receive(:new)).with(paginated_endpoint).and_return(api_caller)
          allow(api_caller).to(receive(:get)).and_return(response_hash)
        end

        it 'returns empty array' do
          objects = Marqeta::ApiObject.object_list(Marqeta::User, endpoint)
          expect(objects.length).to eq(0)
        end
      end

      context 'when api returns all the results in first call' do
        let(:response_hash) { { 'data' => data_array, 'is_more' => false } }
        let(:data_array) do
          [
            { token: 'token1' },
            { token: 'token2' }
          ]
        end
        let(:paginated_endpoint) { "#{endpoint}?count=100&start_index=0" }
        let(:api_caller) { instance_double(Marqeta::ApiCaller) }

        before do
          allow(Marqeta::ApiCaller).to(receive(:new)).with(paginated_endpoint).and_return(api_caller)
          allow(api_caller).to(receive(:get)).and_return(response_hash)
        end

        it 'returns array of objects with expected values' do
          objects = Marqeta::ApiObject.object_list(Marqeta::User, endpoint)
          expect(objects.map(&:class).uniq).to eq([Marqeta::User])
          expect(objects.map(&:token)).to eq(%w[token1 token2])
        end
      end

      context 'when api returns paginated results' do
        let(:response_hash1) { { 'data' => data_array1, 'is_more' => true } }
        let(:response_hash2) { { 'data' => data_array2, 'is_more' => true } }
        let(:response_hash3) { { 'data' => data_array3, 'is_more' => false } }
        let(:data_array1) do
          [
            { token: 'token1' },
            { token: 'token2' }
          ]
        end
        let(:data_array2) do
          [
            { token: 'token3' },
            { token: 'token4' }
          ]
        end
        let(:data_array3) do
          [
            { token: 'token5' }
          ]
        end
        let(:paginated_endpoint1) { "#{endpoint}?count=100&start_index=0" }
        let(:paginated_endpoint2) { "#{endpoint}?count=100&start_index=100" }
        let(:paginated_endpoint3) { "#{endpoint}?count=100&start_index=200" }
        let(:api_caller1) { instance_double(Marqeta::ApiCaller) }
        let(:api_caller2) { instance_double(Marqeta::ApiCaller) }
        let(:api_caller3) { instance_double(Marqeta::ApiCaller) }

        before do
          allow(Marqeta::ApiCaller).to(receive(:new)).with(paginated_endpoint1).and_return(api_caller1)
          allow(Marqeta::ApiCaller).to(receive(:new)).with(paginated_endpoint2).and_return(api_caller2)
          allow(Marqeta::ApiCaller).to(receive(:new)).with(paginated_endpoint3).and_return(api_caller3)
          allow(api_caller1).to(receive(:get)).and_return(response_hash1)
          allow(api_caller2).to(receive(:get)).and_return(response_hash2)
          allow(api_caller3).to(receive(:get)).and_return(response_hash3)
        end

        it 'returns array of objects with expected values' do
          objects = Marqeta::ApiObject.object_list(Marqeta::User, endpoint)
          expect(objects.map(&:class).uniq).to eq([Marqeta::User])
          expect(objects.map(&:token)).to eq(%w[token1 token2 token3 token4 token5])
        end
      end
    end
  end

  describe 'instance methods' do
    subject(:api_object) { Marqeta::ApiObject.new(attributes_hash) }

    let(:attributes_hash) { { a: 1, b: 2, c: 2 } }

    describe 'attributes hash' do
      before do
        allow(api_object)
          .to(receive(:accessible_attributes))
          .and_return(%i[a b])
      end

      it 'allows whitelisted attributes to be called as methods' do
        expect(api_object.a).to eq(1)
        expect(api_object.b).to eq(2)
      end

      it 'raises error when calling non-whitelisted attribute as method' do
        expect { api_object.c }.to raise_error(NoMethodError)
      end
    end
  end
end
