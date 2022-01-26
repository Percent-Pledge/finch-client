# frozen_string_literal: true

RSpec.describe Finch::Client::PagedResourceCollection do
  before do
    Finch::Client.configure do |config|
      config.client_id = '12345'
      config.client_secret = 'abcdef'
      config.sandbox = false
    end
  end

  describe '#initialize' do
    it 'sets @raw to the raw data' do
      data = { 'name' => 'Finch' }
      resource = described_class.new(data)

      expect(resource.raw).to eq(data)
    end
  end
end
