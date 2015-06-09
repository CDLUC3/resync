require 'spec_helper'

module Resync
  RSpec.shared_examples 'a URI field' do

    # TODO: Find a better way to express this
    def new_instance(**args)
      required_args = (defined? required_arguments) ? required_arguments : {}
      required_args.delete(:uri)
      args = required_args.merge(args)
      described_class.new(**args)
    end

    it 'accepts a URI' do
      uri = URI('http://example.org/')
      instance = new_instance(uri: uri)
      expect(instance.uri).to eq(uri)
    end

    it 'accepts a string URI' do
      uri = 'http://example.org/'
      instance = new_instance(uri: uri)
      expect(instance.uri).to eq(URI(uri))
    end

    it 'accepts a string URI with extra whitespace' do
      uri_val = '
                  http://example.org/
                '
      instance = new_instance(uri: uri_val)
      expect(instance.uri).to eq(URI('http://example.org/'))
    end

    it 'rejects an invalid URI' do
      invalid_url = 'I am not a valid URI'
      expect { new_instance(uri: invalid_url) }.to raise_error(URI::InvalidURIError)
    end

    it 'requires a URI' do
      expect { new_instance }.to raise_error(ArgumentError)
    end

  end
end
