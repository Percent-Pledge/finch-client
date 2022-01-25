# frozen_string_literal: true

RSpec.describe Finch::Client::Configuration do
  describe '#client_id' do
    it 'returns the client ID' do
      config = described_class.new
      config.client_id = '12345'

      expect(config.client_id).to eq('12345')
    end

    it 'raises if client ID is not set' do
      expect { described_class.new.client_id }.to raise_error(ArgumentError, 'Finch client_id must be set')
    end
  end

  describe '#client_secret' do
    it 'returns the client secret' do
      config = described_class.new
      config.client_secret = 'abcdef'

      expect(config.client_secret).to eq('abcdef')
    end

    it 'raises if client secret is not set' do
      expect { described_class.new.client_secret }.to raise_error(ArgumentError, 'Finch client_secret must be set')
    end
  end

  describe '#sandbox' do
    it 'returns the sandbox flag' do
      config = described_class.new
      config.sandbox = true

      expect(config.sandbox).to be(true)
    end

    it 'returns false if sandbox is not set' do
      expect(described_class.new.sandbox).to be(false)
    end
  end
end
