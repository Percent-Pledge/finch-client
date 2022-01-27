# frozen_string_literal: true

RSpec.describe Finch::Client::API do
  before do
    Finch::Client.configure do |config|
      config.client_id = '12345'
      config.client_secret = 'abcdef'
      config.sandbox = false
    end
  end

  describe 'class methods' do
    it 'sets the base_uri' do
      expect(described_class.base_uri).to eq('https://api.tryfinch.com')
    end

    it 'set the format to JSON' do
      expect(described_class.format).to eq(:json)
    end
  end

  describe '#initialize' do
    it 'sets default headers' do
      described_class.new('letmein')

      headers = described_class.default_options[:headers]

      expect(headers['Authorization']).to eq('Bearer letmein')
      expect(headers['Content-Type']).to eq('application/json')
      expect(headers['Finch-API-Version']).to eq('2020-09-17')
    end
  end
end
