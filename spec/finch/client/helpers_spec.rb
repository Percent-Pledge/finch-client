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

  describe '#deep_symbolize_keys' do
    it 'symbolizes keys in a hash' do
      expect(deep_symbolize_keys('a' => 1, 'b' => 2)).to(eq(a: 1, b: 2))
    end

    it 'symbolizes keys in nested hashes' do
      expect(deep_symbolize_keys('a' => { 'b' => 2 })).to(eq(a: { b: 2 }))
    end

    it 'symbolizes keys in arrays of hashes' do
      expect(deep_symbolize_keys([{ 'a' => 1 }, { 'b' => 2 }])).to(eq([{ a: 1 }, { b: 2 }]))
    end

    it 'handles mixed nested structures' do
      input = {
        'a' => [
          { 'b' => 2 },
          { 'c' => { 'd' => 4 } }
        ],
        'e' => 5
      }
      expected = {
        a: [
          { b: 2 },
          { c: { d: 4 } }
        ],
        e: 5
      }
      expect(deep_symbolize_keys(input)).to(eq(expected))
    end

    it 'returns non-hash, non-array objects unchanged' do
      expect(deep_symbolize_keys(42)).to(eq(42))
      expect(deep_symbolize_keys('string')).to(eq('string'))
      expect(deep_symbolize_keys(nil)).to(be_nil)
    end
  end
end
