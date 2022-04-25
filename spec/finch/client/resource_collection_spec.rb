# frozen_string_literal: true

RSpec.describe Finch::Client::ResourceCollection do
  before do
    Finch::Client.configure do |config|
      config.client_id = '12345'
      config.client_secret = 'abcdef'
      config.sandbox = false
    end
  end

  describe '#initialize' do
    it 'maps data into Resource instances' do
      data = [{ 'name' => 'Finch', 'nested' => { 'id' => 1 } }]
      resource = described_class.new(data)

      expect(resource.data).to all(be_a(Finch::Client::Resource))
    end

    it 'allows you to set headers' do
      resource = described_class.new({}, { 'X-Finch-Test' => 'test' })

      expect(resource.headers['X-Finch-Test']).to eq('test')
    end

    it 'sets a default value for headers' do
      resource = described_class.new({})

      expect(resource.headers).to eq({})
    end
  end

  describe '#each' do
    it 'yields each Resource' do
      data = [{ 'name' => 'Finch', 'nested' => { 'id' => 1 } }]
      resource = described_class.new(data)

      expect { |block| resource.each(&block) }.to yield_control.exactly(1).times
    end
  end
end
