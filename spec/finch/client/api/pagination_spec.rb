# frozen_string_literal: true

RSpec.describe(Finch::Client::API::Pagination) do
  include described_class

  let(:batch_size) { described_class::BATCH_SIZE }
  let(:response_double) { double }

  describe '#with_pagination' do
    it 'provides pagination options to the block' do
      allow(response_double).to(receive(:call).and_return(build_resouce_collection))

      with_pagination({}) { |options| response_double.call(options) }

      expect(response_double).to(have_received(:call).once)
      expect(response_double).to(have_received(:call).with({ limit: batch_size, offset: 0 }))
    end

    it 'calls the block multiple times if there is more data to be loaded' do
      allow(response_double).to(receive(:call).and_return(
        build_resouce_collection([1, 2]),
        build_resouce_collection
      ))

      with_pagination({}) { |options| response_double.call(options) }

      expect(response_double).to(have_received(:call).twice)
      expect(response_double).to(have_received(:call).with({ limit: batch_size, offset: 0 }))
      expect(response_double).to(have_received(:call).with({ limit: batch_size, offset: batch_size }))
    end

    it 'combines multiple responses into one' do
      allow(response_double).to(receive(:call).and_return(
        build_resouce_collection([1, 2]),
        build_resouce_collection([3, 4]),
        build_resouce_collection
      ))

      result = with_pagination({}) { |options| response_double.call(options) }

      expect(result.data).to(eq([1, 2, 3, 4]))
    end

    it 'does not paginate if the user specifies an offset or limit' do
      allow(response_double).to(receive(:call).and_return(build_resouce_collection([1, 2])))

      with_pagination({ limit: 100 }) { |options| response_double.call(options) }

      expect(response_double).to(have_received(:call).once)
      expect(response_double).to(have_received(:call).with({ limit: 100 }))
    end

    it 'calls a backoff function if there is a rate limit error' do
      # Overwrite the default backoff algorithm to make it easier to test
      backoff_double = double(:callable, call: 0)
      stub_const("#{described_class}::BACKOFF_ALGORITHM", backoff_double)

      allow(response_double).to(receive(:call)
        .and_invoke(
          ->(_) { raise(Finch::Client::API::APIError.new('Rate limit error', double(:res, code: 429))) },
          ->(_) { build_resouce_collection }
        ))

      with_pagination({}) { |options| response_double.call(options) }

      expect(backoff_double).to(have_received(:call).once)
    end

    it 'raises error if rate limit error count exceeds max' do
      # Overwrite the default backoff algorithm to make it easier to test
      backoff_double = double(:callable, call: 0)
      stub_const("#{described_class}::BACKOFF_ALGORITHM", backoff_double)
      stub_const("#{described_class}::MAX_RATE_LIMIT_ERRORS", 2)

      allow(response_double).to(receive(:call)
        .and_raise(Finch::Client::API::APIError.new('Rate limit error', double(:res, code: 429))))

      expect do
        with_pagination({}) { |options| response_double.call(options) }
      end.to(raise_error(Finch::Client::API::APIError, 'Rate limit error'))
    end

    it 'raises other errors immediately' do
      allow(response_double).to(receive(:call)
        .and_raise(Finch::Client::API::APIError.new('Other error', double(:res, code: 500))))

      expect do
        with_pagination({}) { |options| response_double.call(options) }
      end.to(raise_error(Finch::Client::API::APIError, 'Other error'))
    end
  end

  describe '#with_batching' do
    before do
      stub_const("#{described_class}::BATCH_SIZE", 1)
    end

    it 'splits the request objects into batches' do
      allow(response_double).to(receive(:call).and_return(build_resouce_collection))

      with_batching([1, 2, 3]) { |batch| response_double.call(batch) }

      expect(response_double).to(have_received(:call).exactly(3).times)
    end

    it 'formats the request objects as the expected JSON' do
      allow(response_double).to(receive(:call).and_return(build_resouce_collection))

      with_batching([1, 2]) { |batch| response_double.call(batch) }

      expect(response_double).to(have_received(:call).with('{"requests":[1]}'))
      expect(response_double).to(have_received(:call).with('{"requests":[2]}'))
    end

    it 'returns a combined response' do
      allow(response_double).to(receive(:call).and_return(
        build_resouce_collection([:foo]),
        build_resouce_collection([:bar]),
        build_resouce_collection
      ))

      result = with_batching([1, 2]) { |batch| response_double.call(batch) }

      expect(result.data).to(eq(%i[foo bar]))
    end
  end

  private

  def build_resouce_collection(data = [], headers = nil, raw_response = nil)
    Finch::Client::ResourceCollection.new(data, headers, raw_response)
  end
end
