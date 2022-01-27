# frozen_string_literal: true

RSpec.describe Finch::Client::API::Management do
  before do
    Finch::Client.configure do |config|
      config.client_id = '12345'
      config.client_secret = 'abcdef'
      config.sandbox = false
    end
  end

  let(:dummy_class) do
    Class.new(Finch::Client::API) do
      base_uri 'https://example.com'

      def initialize; end
    end
  end

  describe '#introspect' do
    it 'makes a GET request to the introspect path' do
      stub_request(:get, 'https://example.com/introspect')
        .to_return(status: 200, body: {}.to_json)

      dummy_class.new.introspect
    end
  end

  describe '#providers' do
    it 'makes a GET request to the providers path' do
      stub_request(:get, 'https://example.com/providers')
        .to_return(status: 200, body: {}.to_json)

      dummy_class.new.providers
    end
  end

  describe '#disconnect' do
    it 'makes a POST request to the disconnect path' do
      stub_request(:post, 'https://example.com/disconnect')
        .to_return(status: 200, body: {}.to_json)

      dummy_class.new.disconnect
    end
  end
end
