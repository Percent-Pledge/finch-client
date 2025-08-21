# frozen_string_literal: true

RSpec.describe(Finch::Client::Connect::Sessions) do
  before do
    Finch::Client.configure do |config|
      config.client_id = '12345'
      config.client_secret = 'abcdef'
      config.sandbox = false
    end
  end

  describe '.create' do
    let(:params) do
      {
        customer_id: 'customer_123',
        customer_name: 'Acme Corp',
        products: ['company'],
        integration: {
          provider: 'gusto'
        }
      }
    end

    it 'includes basic auth header' do
      # Will automatically fail if the request doesn't match the stubbed response
      stub_request(:post, 'https://api.tryfinch.com/connect/sessions')
        .with(
          basic_auth: [Finch::Client.configuration.client_id, Finch::Client.configuration.client_secret],
          headers: {
            'Content-Type' => 'application/json',
            'Finch-API-Version' => '2020-09-17'
          },
          body: params.to_json
        )
        .to_return(
          status: 200,
          headers: { content_type: 'application/json' },
          body: {
            session_id: 'session_123',
            connect_url: 'https://connect.tryfinch.com/session_123'
          }.to_json
        )

      described_class.create(params)
    end

    it 'accepts custom finch_api_version' do
      stub_request(:post, 'https://api.tryfinch.com/connect/sessions')
        .with(
          headers: {
            'Content-Type' => 'application/json',
            'Finch-API-Version' => '2021-01-01'
          }
        )
        .to_return(
          status: 200,
          headers: { content_type: 'application/json' },
          body: {
            session_id: 'session_123',
            connect_url: 'https://connect.tryfinch.com/session_123'
          }.to_json
        )

      described_class.create(params, finch_api_version: '2021-01-01')
    end

    it 'returns session data on success' do
      response_body = {
        session_id: 'session_123',
        connect_url: 'https://connect.tryfinch.com/session_123'
      }

      stub_request(:post, 'https://api.tryfinch.com/connect/sessions')
        .to_return(
          status: 200,
          headers: { content_type: 'application/json' },
          body: response_body.to_json
        )

      result = described_class.create(params)

      expect(result).to(be_a(Hash))
      expect(result[:session_id]).to(eq('session_123'))
      expect(result[:connect_url]).to(eq('https://connect.tryfinch.com/session_123'))
    end

    it 'raises SessionError on API error' do
      error_response = {
        message: 'Invalid customer_id',
        name: 'invalid_request',
        code: 400,
        finch_code: 'invalid_customer_id'
      }

      stub_request(:post, 'https://api.tryfinch.com/connect/sessions')
        .to_return(
          status: 400,
          headers: { content_type: 'application/json' },
          body: error_response.to_json
        )

      expect do
        described_class.create(params)
      end.to(raise_error(Finch::Client::Connect::Sessions::SessionError)) do |error|
        expect(error.message).to(eq('Invalid customer_id'))
        expect(error.error_name).to(eq('invalid_request'))
        expect(error.http_code).to(eq(400))
        expect(error.finch_code).to(eq('invalid_customer_id'))
      end
    end

    it 'sends JSON body with correct parameters' do
      stub_request(:post, 'https://api.tryfinch.com/connect/sessions')
        .with(body: params.to_json)
        .to_return(
          status: 200,
          headers: { content_type: 'application/json' },
          body: {
            session_id: 'session_123',
            connect_url: 'https://connect.tryfinch.com/session_123'
          }.to_json
        )

      described_class.create(params)
    end
  end

  describe '.reauthenticate' do
    let(:params) do
      {
        connection_id: 'conn_123',
        customer_id: 'customer_123',
        customer_name: 'Acme Corp',
        products: ['company']
      }
    end

    it 'includes basic auth header' do
      # Will automatically fail if the request doesn't match the stubbed response
      stub_request(:post, 'https://api.tryfinch.com/connect/sessions/reauthenticate')
        .with(
          basic_auth: [Finch::Client.configuration.client_id, Finch::Client.configuration.client_secret],
          headers: {
            'Content-Type' => 'application/json'
          },
          body: params.to_json
        )
        .to_return(
          status: 200,
          headers: { content_type: 'application/json' },
          body: {
            session_id: 'session_456',
            connect_url: 'https://connect.tryfinch.com/session_456'
          }.to_json
        )

      described_class.reauthenticate(params)
    end

    it 'returns session data on success' do
      response_body = {
        session_id: 'session_456',
        connect_url: 'https://connect.tryfinch.com/session_456'
      }

      stub_request(:post, 'https://api.tryfinch.com/connect/sessions/reauthenticate')
        .to_return(
          status: 200,
          headers: { content_type: 'application/json' },
          body: response_body.to_json
        )

      result = described_class.reauthenticate(params)

      expect(result).to(be_a(Hash))
      expect(result[:session_id]).to(eq('session_456'))
      expect(result[:connect_url]).to(eq('https://connect.tryfinch.com/session_456'))
    end

    it 'raises SessionError on API error' do
      error_response = {
        message: 'Connection not found',
        name: 'not_found',
        code: 404,
        finch_code: 'connection_not_found'
      }

      stub_request(:post, 'https://api.tryfinch.com/connect/sessions/reauthenticate')
        .to_return(
          status: 404,
          headers: { content_type: 'application/json' },
          body: error_response.to_json
        )

      expect do
        described_class.reauthenticate(params)
      end.to(raise_error(Finch::Client::Connect::Sessions::SessionError)) do |error|
        expect(error.message).to(eq('Connection not found'))
        expect(error.error_name).to(eq('not_found'))
        expect(error.http_code).to(eq(404))
        expect(error.finch_code).to(eq('connection_not_found'))
      end
    end

    it 'sends JSON body with correct parameters' do
      stub_request(:post, 'https://api.tryfinch.com/connect/sessions/reauthenticate')
        .with(body: params.to_json)
        .to_return(
          status: 200,
          headers: { content_type: 'application/json' },
          body: {
            session_id: 'session_456',
            connect_url: 'https://connect.tryfinch.com/session_456'
          }.to_json
        )

      described_class.reauthenticate(params)
    end

    it 'does not include Finch-API-Version header' do
      stub_request(:post, 'https://api.tryfinch.com/connect/sessions/reauthenticate')
        .with { |request| !request.headers.key?('Finch-Api-Version') }
        .to_return(
          status: 200,
          headers: { content_type: 'application/json' },
          body: {
            session_id: 'session_456',
            connect_url: 'https://connect.tryfinch.com/session_456'
          }.to_json
        )

      described_class.reauthenticate(params)
    end
  end
end
