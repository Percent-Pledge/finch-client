# frozen_string_literal: true

RSpec.describe Finch::Client::API::Payroll do
  before do
    Finch::Client.configure do |config|
      config.client_id = '12345'
      config.client_secret = 'abcdef'
      config.sandbox = false
    end
  end

  let(:dummy_class) do
    klass = Class.new(Finch::Client::API) do
      base_uri 'https://example.com'
    end

    klass.new('access_token')
  end

  describe '#payment' do
    it 'makes a GET request to the payment path' do
      stub_request(:get, 'https://example.com/employer/payment')
        .to_return(status: 200, body: {}.to_json)

      dummy_class.payment
    end

    it 'lets you specify query parameters' do
      stub_request(:get, 'https://example.com/employer/payment?limit=1')
        .to_return(status: 200, body: {}.to_json)

      dummy_class.payment(limit: 1)
    end
  end

  describe '#pay_statement' do
    it 'makes a POST request to the pay_statement path' do
      stub_request(:post, 'https://example.com/employer/pay-statement')
        .to_return(status: 200, body: { responses: [] }.to_json)

      dummy_class.pay_statement({ payment_id: 1 })
    end

    it 'returns an array of Resource objects for a namespaced collection' do
      stub_request(:post, 'https://example.com/employer/pay-statement')
        .to_return(status: 200, body: { responses: [{ name: 'Finch' }] }.to_json)

      result = dummy_class.pay_statement({})

      expect(result).to be_a(Finch::Client::ResourceCollection)
      expect(result.first).to be_a(Finch::Client::Resource)
      expect(result.first.name).to eq('Finch')
    end

    it 'lets you specify which payments to look up' do
      stub_request(:post, 'https://example.com/employer/pay-statement')
        .with(body: { requests: [{ payment_id: 1 }] }.to_json)
        .to_return(status: 200, body: { responses: [] }.to_json)

      dummy_class.pay_statement({ payment_id: 1 })
    end

    it 'lets you specify multiple payments to look up' do
      stub_request(:post, 'https://example.com/employer/pay-statement')
        .with(body: { requests: [{ payment_id: 1 }, { payment_id: 2 }] }.to_json)
        .to_return(status: 200, body: { responses: [] }.to_json)

      dummy_class.pay_statement([{ payment_id: 1 }, { payment_id: 2 }])
    end
  end
end
