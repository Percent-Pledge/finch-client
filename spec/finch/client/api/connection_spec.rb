# frozen_string_literal: true

RSpec.describe Finch::Client::API::Connection do
  before do
    Finch::Client.configure do |config|
      config.client_id = '12345'
      config.client_secret = 'abcdef'
      config.sandbox = false
    end
  end

  let(:dummy_class) do
    Class.new do
      include HTTParty
      include Finch::Client::API::Connection

      base_uri 'https://example.com'
      format :json
    end
  end

  describe '#get' do
    it 'makes a GET request to the specified path' do
      stub_request(:get, 'https://example.com/test').to_return(status: 200, body: '{}')

      dummy_class.new.get('/test')
    end

    it 'returns a Resource object for a singular resource' do
      stub_request(:get, 'https://example.com/test')
        .to_return(status: 200, body: { name: 'Finch' }.to_json)

      expect(dummy_class.new.get('/test')).to be_a(Finch::Client::Resource)
    end

    it 'returns an array of Resource objects for a collection' do
      stub_request(:get, 'https://example.com/test')
        .to_return(status: 200, body: [{ name: 'Finch' }].to_json)

      expect(dummy_class.new.get('/test')).to be_a(Array)
      expect(dummy_class.new.get('/test').first).to be_a(Finch::Client::Resource)
    end

    it 'throws if there was an API error' do
      stub_request(:get, 'https://example.com/test')
        .to_return(status: 429, body: { message: 'rate_limited' }.to_json)

      expect { dummy_class.new.get('/test') }.to raise_error(Finch::Client::API::APIError, 'rate_limited')
    end
  end

  describe '#post' do
    it 'makes a POST request to the specified path' do
      stub_request(:post, 'https://example.com/test').to_return(status: 201, body: '{}')

      dummy_class.new.post('/test')
    end

    it 'returns a Resource object for a singular resource' do
      stub_request(:post, 'https://example.com/test')
        .to_return(status: 201, body: { name: 'Finch' }.to_json)

      expect(dummy_class.new.post('/test')).to be_a(Finch::Client::Resource)
    end

    it 'returns an array of Resource objects for a collection' do
      stub_request(:post, 'https://example.com/test')
        .to_return(status: 201, body: [{ name: 'Finch' }].to_json)

      expect(dummy_class.new.post('/test')).to be_a(Array)
      expect(dummy_class.new.post('/test').first).to be_a(Finch::Client::Resource)
    end

    it 'throws if there was an API error' do
      stub_request(:post, 'https://example.com/test')
        .to_return(status: 429, body: { message: 'rate_limited' }.to_json)

      expect { dummy_class.new.post('/test') }.to raise_error(Finch::Client::API::APIError, 'rate_limited')
    end
  end
end
