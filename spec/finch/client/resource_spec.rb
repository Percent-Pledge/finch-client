# frozen_string_literal: true

RSpec.describe Finch::Client::Resource do
  before do
    Finch::Client.configure do |config|
      config.client_id = '12345'
      config.client_secret = 'abcdef'
      config.sandbox = false
    end
  end

  describe '#initialize' do
    it 'deep-transforms data attribute keys to symbols' do
      data = { 'name' => 'Finch', 'nested' => { 'id' => 1 } }
      resource = described_class.new(data)

      expect(resource.data).to include({ name: 'Finch' })
      expect(resource.data[:nested].data).to eq({ id: 1 })
    end

    it 'creates nested resources for hashes' do
      data = { 'nested' => { 'id' => 1 } }
      resource = described_class.new(data)

      expect(resource.nested).to be_a(described_class)
    end

    it 'creates nested resources for arrays' do
      data = { 'nested' => [{ 'id' => 1 }, 'asdf'] }
      resource = described_class.new(data)

      expect(resource.nested).to be_a(Array)
      expect(resource.nested.first).to be_a(described_class)
      expect(resource.nested.last).to be_a(String)
    end
  end

  describe '#to_h' do
    it 'returns the raw data as a hash' do
      data = { 'name' => 'Finch', 'nested' => { 'id' => 1 } }
      resource = described_class.new(data)

      expect(resource.to_h).to eq(data)
    end
  end

  describe '#method_missing' do
    it 'delegates to the data attribute' do
      data = { 'name' => 'Finch' }
      resource = described_class.new(data)

      expect(resource.name).to eq(data['name'])
    end

    it 'raises an error if the data attribute does not respond to the method' do
      resource = described_class.new({})

      expect { resource.foo }.to raise_error(NoMethodError)
    end
  end

  describe '#respond_to_missing?' do
    it 'returns true if the data attribute responds to the method' do
      data = { 'name' => 'Finch' }
      resource = described_class.new(data)

      expect(resource.respond_to?(:name)).to be(true)
    end

    it 'returns false if the data attribute does not respond to the method' do
      resource = described_class.new({})

      expect(resource.respond_to?(:foo)).to be(false)
    end
  end
end
