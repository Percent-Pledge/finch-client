# frozen_string_literal: true

RSpec.describe(Finch::Client::Connect) do
  before do
    Finch::Client.configure do |config|
      config.client_id = '12345'
      config.client_secret = 'abcdef'
      config.sandbox = false
    end
  end

  describe '#authorization_uri' do
    it 'returns a URI' do
      expect(described_class.authorization_uri('example.com', 'company')).to(be_a(URI::HTTPS))
    end

    it 'includes the correct path and params' do
      uri = described_class.authorization_uri('example.com', 'company')

      expect(uri.host).to(eq('connect.tryfinch.com'))
      expect(uri.path).to(eq('/authorize'))
      expect(uri.query).to(eq('redirect_uri=example.com&products=company&client_id=12345'))
    end

    it 'includes the sandbox param if configured' do
      Finch::Client.configuration.sandbox = true

      uri = described_class.authorization_uri('example.com', 'company')

      expect(uri.query).to(include('sandbox=true'))
    end

    it 'optionally includes additional params' do
      uri = described_class.authorization_uri('example.com', 'company', { scope: 'read' })

      expect(uri.query).to(include('scope=read'))
    end
  end

  describe '#request_access_token' do
    it 'includes basic auth header' do
      # Will automatically fail if the request doesn't matched the stubbed response
      stub_request(:post, 'https://api.tryfinch.com/auth/token')
        .with(basic_auth: [Finch::Client.configuration.client_id, Finch::Client.configuration.client_secret])
        .to_return(headers: { content_type: 'application/json' }, body: { access_token: '' }.to_json)

      described_class.request_access_token('example.com', '12345')
    end

    it 'returns the access response' do
      response = {
        access_token: 'abcdef',
        connection_id: '12345'
      }

      stub_request(:post, 'https://api.tryfinch.com/auth/token')
        .to_return(headers: { content_type: 'application/json' }, body: response.to_json)

      result = described_class.request_access_token('example.com', '54321')

      expect(result).to(be_a(Hash))
      expect(result[:access_token]).to(eq('abcdef'))
      expect(result[:connection_id]).to(eq('12345'))
    end

    it 'throws if request was unsuccessful' do
      stub_request(:post, 'https://api.tryfinch.com/auth/token')
        .to_return(
          status: 401,
          headers: { content_type: 'application/json' },
          body: { message: 'Invalid code' }.to_json
        )

      expect do
        described_class.request_access_token('example.com', '12345')
      end.to(raise_error(Finch::Client::Connect::AccessTokenError, 'Invalid code'))
    end
  end
end
