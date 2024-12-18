# frozen_string_literal: true

RSpec.describe(Finch::Client::API::Connection) do
  before do
    Finch::Client.configure do |config|
      config.client_id = '12345'
      config.client_secret = 'abcdef'
      config.sandbox = false
    end
  end

  let(:dummy_class) do
    klass = Class.new(Finch::Client::API) do
      base_uri 'https://example.com'
    end

    klass.new('access_token')
  end

  describe 'all request types' do
    it 'returns a Resource object for a singular resource' do
      stub_request(:get, 'https://example.com/test')
        .to_return(status: 200, body: { name: 'Finch' }.to_json)

      expect(dummy_class.get('/test')).to(be_a(Finch::Client::Resource))
    end

    it 'passes header data to singular resources' do
      stub_request(:get, 'https://example.com/test')
        .to_return(status: 200, body: {}.to_json, headers: { 'X-Finch-Test' => 'test' })

      expect(dummy_class.get('/test').headers['X-Finch-Test']).to(eq('test'))
    end

    it 'returns a collection of Resource objects for a collection' do
      stub_request(:get, 'https://example.com/test')
        .to_return(status: 200, body: [{ name: 'Finch' }].to_json)

      expect(dummy_class.get('/test')).to(be_a(Finch::Client::ResourceCollection))
      expect(dummy_class.get('/test').first).to(be_a(Finch::Client::Resource))
    end

    it 'passes header data to a collection of resources' do
      stub_request(:get, 'https://example.com/test')
        .to_return(status: 200, body: [{}].to_json, headers: { 'X-Finch-Test' => 'test' })

      expect(dummy_class.get('/test').headers.first['X-Finch-Test']).to(eq('test'))
    end

    it 'throws if there was an API error' do
      stub_request(:get, 'https://example.com/test')
        .to_return(status: 429, body: { message: 'rate_limited' }.to_json)

      expect { dummy_class.get('/test') }.to(raise_error(Finch::Client::API::APIError, 'rate_limited'))
    end

    it 'returns full response in error' do
      stub_request(:get, 'https://example.com/test')
        .to_return(status: 429, body: { message: 'rate_limited' }.to_json)

      expect { dummy_class.get('/test') }.to(raise_error) do |error|
        expect(error.response).to(be_a(HTTParty::Response))
      end
    end
  end

  describe '#get' do
    it 'makes a GET request to the specified path' do
      stub_request(:get, 'https://example.com/test').to_return(status: 200, body: '{}')

      dummy_class.get('/test')
    end
  end

  describe '#post' do
    it 'makes a POST request to the specified path' do
      stub_request(:post, 'https://example.com/test').to_return(status: 201, body: '{}')

      dummy_class.post('/test')
    end
  end

  describe '#delete' do
    it 'makes a DELETE request to the specified path' do
      stub_request(:delete, 'https://example.com/test').to_return(status: 201, body: '{}')

      dummy_class.delete('/test')
    end
  end
end
