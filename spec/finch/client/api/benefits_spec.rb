# frozen_string_literal: true

RSpec.describe Finch::Client::API::Benefits do
  before do
    Finch::Client.configure do |config|
      config.client_id = '12345'
      config.client_secret = 'abcdef'
      config.sandbox = false
    end
  end

  let(:dummy_class) do
    Class.new(Finch::Client::API) do
      base_uri 'https://example.com'

      def initialize; end
    end
  end

  describe '#benefits' do
    it 'makes a GET request to the benefits path' do
      stub_request(:get, 'https://example.com/employer/benefits')
        .to_return(status: 200, body: {}.to_json)

      dummy_class.new.benefits
    end
  end

  describe '#benefit' do
    it 'makes a GET request to the benefit path' do
      stub_request(:get, 'https://example.com/employer/benefits/12345')
        .to_return(status: 200, body: {}.to_json)

      dummy_class.new.benefit(12_345)
    end
  end

  describe '#benefits_metadata' do
    it 'makes a GET request to the benefits metadata path' do
      stub_request(:get, 'https://example.com/employer/benefits/meta')
        .to_return(status: 200, body: {}.to_json)

      dummy_class.new.benefits_metadata
    end
  end

  describe '#create_benefit' do
    it 'makes a POST request to the benefits path' do
      stub_request(:post, 'https://example.com/employer/benefits')
        .to_return(status: 200, body: {}.to_json)

      dummy_class.new.create_benefit({})
    end

    it 'lets you specify request body' do
      stub_request(:post, 'https://example.com/employer/benefits')
        .with(body: { benefit_data: {} }.to_json)
        .to_return(status: 200, body: {}.to_json)

      dummy_class.new.create_benefit({ benefit_data: {} })
    end
  end

  describe '#update_benefit' do
    it 'makes a POST request to the benefit path' do
      stub_request(:post, 'https://example.com/employer/benefits/12345')
        .to_return(status: 200, body: {}.to_json)

      dummy_class.new.update_benefit(12_345, {})
    end

    it 'lets you specify request body' do
      stub_request(:post, 'https://example.com/employer/benefits/12345')
        .with(body: { benefit_data: {} }.to_json)
        .to_return(status: 200, body: {}.to_json)

      dummy_class.new.update_benefit(12_345, { benefit_data: {} })
    end
  end

  describe '#benefit_enrolled_individuals' do
    it 'makes a GET request to the benefit enrolled individuals path' do
      stub_request(:get, 'https://example.com/employer/benefits/12345/enrolled')
        .to_return(status: 200, body: {}.to_json)

      dummy_class.new.benefit_enrolled_individuals(12_345)
    end
  end

  describe '#benefits_for_individual' do
    it 'makes a GET request to the benefits for individual path' do
      stub_request(:get, 'https://example.com/employer/benefits/12345/individuals?individual_ids=56789')
        .to_return(status: 200, body: {}.to_json)

      dummy_class.new.benefits_for_individual(12_345, 56_789)
    end

    it 'lets you specify multiple individual_ids' do
      stub_request(:get, 'https://example.com/employer/benefits/12345/individuals?individual_ids=56789,12345')
        .to_return(status: 200, body: {}.to_json)

      dummy_class.new.benefits_for_individual(12_345, [56_789, 12_345])
    end
  end

  describe '#enroll_individual_in_benefits' do
    it 'makes a POST request to the benefit path' do
      stub_request(:post, 'https://example.com/employer/benefits/12345/individuals')
        .to_return(status: 200, body: {}.to_json)

      dummy_class.new.enroll_individual_in_benefits(12_345, {})
    end

    it 'lets you specify request body' do
      stub_request(:post, 'https://example.com/employer/benefits/12345/individuals')
        .with(body: [{ individual_data: {} }].to_json)
        .to_return(status: 200, body: {}.to_json)

      dummy_class.new.enroll_individual_in_benefits(12_345, { individual_data: {} })
    end
  end

  describe '#unenroll_individual_from_benefits' do
    it 'makes a DELETE request to the benefit path' do
      stub_request(:delete, 'https://example.com/employer/benefits/12345/individuals')
        .with(body: { individual_ids: [56_789] }.to_json)
        .to_return(status: 200, body: {}.to_json)

      dummy_class.new.unenroll_individual_from_benefits(12_345, 56_789)
    end

    it 'lets you specify multiple individual_ids' do
      stub_request(:delete, 'https://example.com/employer/benefits/12345/individuals')
        .with(body: { individual_ids: [56_789, 12_345] }.to_json)
        .to_return(status: 200, body: {}.to_json)

      dummy_class.new.unenroll_individual_from_benefits(12_345, [56_789, 12_345])
    end
  end
end
