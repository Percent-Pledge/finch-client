# frozen_string_literal: true

RSpec.describe(Finch::Client::Helpers) do
  include described_class

  describe '#array_wrap' do
    it 'wraps nil in an array' do
      expect(array_wrap(nil)).to(eq([]))
    end

    it 'doesnt change arrays' do
      expect(array_wrap([1, 2, 3])).to(eq([1, 2, 3]))
    end

    it 'wraps a single object in an array' do
      expect(array_wrap(1)).to(eq([1]))
    end
  end
end
