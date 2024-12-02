# frozen_string_literal: true

RSpec.describe(Finch::Client::API::Organization) do
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

  describe '#directory' do
    it 'makes a GET request to the directory path' do
      stub_request(:get, 'https://example.com/employer/directory?limit=250&offset=0')
        .to_return(status: 200, body: { individuals: [] }.to_json)

      dummy_class.directory
    end

    it 'lets you specify query parameters' do
      stub_request(:get, 'https://example.com/employer/directory?limit=1')
        .to_return(status: 200, body: { individuals: [] }.to_json)

      dummy_class.directory(limit: 1)
    end

    it 'returns an array of Resource objects for a namespaced collection' do
      stub_request(:get, 'https://example.com/employer/directory?limit=250&offset=0')
        .to_return(status: 200, body: { individuals: [{ name: 'Finch' }] }.to_json)
      stub_request(:get, 'https://example.com/employer/directory?limit=250&offset=250')
        .to_return(status: 200, body: { individuals: [] }.to_json)

      result = dummy_class.directory

      expect(result).to(be_a(Finch::Client::ResourceCollection))
      expect(result.first).to(be_a(Finch::Client::Resource))
      expect(result.first.name).to(eq('Finch'))
    end
  end

  describe '#company' do
    it 'makes a GET request to the company path' do
      stub_request(:get, 'https://example.com/employer/company')
        .to_return(status: 200, body: {}.to_json)

      dummy_class.company
    end
  end

  describe '#individual' do
    it 'makes a POST request to the individual path' do
      stub_request(:post, 'https://example.com/employer/individual')
        .to_return(status: 200, body: { responses: [] }.to_json)

      dummy_class.individual({ individual_id: '1' })
    end

    it 'returns an array of Resource objects for a namespaced collection' do
      stub_request(:post, 'https://example.com/employer/individual')
        .with(body: { requests: [{ individual_id: '1' }] }.to_json)
        .to_return(status: 200, body: { responses: [{ name: 'Finch' }] }.to_json)

      result = dummy_class.individual({ individual_id: '1' })

      expect(result).to(be_a(Finch::Client::ResourceCollection))
      expect(result.first).to(be_a(Finch::Client::Resource))
      expect(result.first.name).to(eq('Finch'))
    end

    it 'lets you specify multiple individual_ids' do
      stub_request(:post, 'https://example.com/employer/individual')
        .with(body: { requests: [{ individual_id: '1' }, { individual_id: '2' }] }.to_json)
        .to_return(status: 200, body: { responses: [] }.to_json)

      dummy_class.individual([{ individual_id: '1' }, { individual_id: '2' }])
    end
  end

  describe '#employment' do
    it 'makes a POST request to the employment path' do
      stub_request(:post, 'https://example.com/employer/employment')
        .with(body: { requests: [{ individual_id: '1' }] }.to_json)
        .to_return(status: 200, body: { responses: [] }.to_json)

      dummy_class.employment({ individual_id: '1' })
    end

    it 'returns an array of Resource objects for a namespaced collection' do
      stub_request(:post, 'https://example.com/employer/employment')
        .with(body: { requests: [{ individual_id: '1' }] }.to_json)
        .to_return(status: 200, body: { responses: [{ name: 'Finch' }] }.to_json)

      result = dummy_class.employment({ individual_id: '1' })

      expect(result).to(be_a(Finch::Client::ResourceCollection))
      expect(result.first).to(be_a(Finch::Client::Resource))
      expect(result.first.name).to(eq('Finch'))
    end

    it 'lets you specify multiple individual_ids' do
      stub_request(:post, 'https://example.com/employer/employment')
        .with(body: { requests: [{ individual_id: '1' }, { individual_id: '2' }] }.to_json)
        .to_return(status: 200, body: { responses: [] }.to_json)

      dummy_class.employment([{ individual_id: '1' }, { individual_id: '2' }])
    end
  end
end
