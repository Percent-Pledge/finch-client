# frozen_string_literal: true

RSpec.describe Finch::Client do
  it 'has a version number' do
    expect(Finch::Client::VERSION).not_to be nil
  end

  describe '#configure' do
    it 'yields the configuration' do
      expect { |b| described_class.configure(&b) }.to yield_with_args(Finch::Client::Configuration)
    end
  end

  describe '#configuration' do
    it 'returns the configuration' do
      expect(described_class.configuration).to be_a(Finch::Client::Configuration)
    end

    it 'returns custom property values' do
      described_class.configure do |config|
        config.client_id = '12345'
        config.client_secret = 'abcdef'
        config.sandbox = true
      end

      expect(described_class.configuration.client_id).to eq('12345')
      expect(described_class.configuration.client_secret).to eq('abcdef')
      expect(described_class.configuration.sandbox).to be(true)
    end
  end
end
