require 'spec_helper'

module Resync
  RSpec.shared_examples 'a URI field' do

    def new_instance(**args)
      described_class.new(**args)
    end

    it 'accepts a URI' do
      uri = URI('http://example.org/')
      instance = new_instance(uri_field => uri)
      expect(instance.send(uri_field)).to eq(uri)
    end

    it 'accepts a string URI' do
      uri = 'http://example.org/'
      instance = new_instance(uri_field => uri)
      expect(instance.send(uri_field)).to eq(URI(uri))
    end

    it 'rejects an invalid URI' do
      invalid_url = 'I am not a valid URI'
      expect { new_instance(uri_field => invalid_url) }.to raise_error(URI::InvalidURIError)
    end

    it 'requires a URI' do
      expect { new_instance }.to raise_error(ArgumentError)
    end

  end
end
