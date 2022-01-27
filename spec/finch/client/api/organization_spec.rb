# frozen_string_literal: true

RSpec.describe Finch::Client::API::Organization do
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
      include Finch::Client::API::Organization

      base_uri 'https://example.com'
      format :json
    end
  end

  describe '#directory' do
    it 'makes a GET request to the directory path' do
      stub_request(:get, 'https://example.com/directory')
        .to_return(status: 200, body: { individuals: [] }.to_json)

      dummy_class.new.directory
    end

    it 'returns an array of Resource objects for a namespaced collection' do
      stub_request(:get, 'https://example.com/directory')
        .to_return(status: 200, body: { individuals: [{ name: 'Finch' }] }.to_json)

      result = dummy_class.new.directory

      expect(result).to be_a(Array)
      expect(result.first).to be_a(Finch::Client::Resource)
      expect(result.first.name).to eq('Finch')
    end
  end

  describe '#company' do
    it 'makes a GET request to the company path' do
      stub_request(:get, 'https://example.com/company')
        .to_return(status: 200, body: {}.to_json)

      dummy_class.new.company
    end
  end
end
