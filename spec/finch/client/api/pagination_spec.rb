# frozen_string_literal: true

RSpec.describe(Finch::Client::API::Pagination) do
  include described_class

  let(:response_double) { double }

  describe '#with_pagination' do
    it 'provides pagination options to the block' do
      allow(response_double).to(receive(:call).and_return(build_resouce_collection))

      with_pagination({}) { |options| response_double.call(options) }

      expect(response_double).to(have_received(:call).with({ limit: 250, offset: 0 }))
    end
  end

  private

  def build_resouce_collection(data = [], headers = nil, raw_response = nil)
    Finch::Client::ResourceCollection.new(data, headers, raw_response)
  end
end
