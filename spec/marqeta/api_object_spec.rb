require 'spec_helper'

describe Marqeta::ApiObject do
  let(:endpoint) { 'foo' }

  before do
    allow(Marqeta::ApiObject)
      .to receive(:endpoint)
      .and_return(endpoint)
  end

  describe 'class methods' do
    describe '.api_create' do
      let(:api_create) { Marqeta::ApiObject.api_create(payload) }
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
        api_create
      end

      it 'posts the payload to an ApiCaller' do
        expect_any_instance_of(Marqeta::ApiCaller)
          .to(receive(:post))
          .with(payload)
        api_create
      end

      it 'creates and returns ApiObject with response sent to initializer' do
        expect(Marqeta::ApiObject)
          .to(receive(:new))
          .with(response_hash)
          .and_call_original
        expect(api_create).to(be_a(Marqeta::ApiObject))
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
