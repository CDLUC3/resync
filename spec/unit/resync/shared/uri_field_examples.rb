require 'spec_helper'

module Resync
  RSpec.shared_examples 'a URI field' do

    # TODO: Find a better way to express this (incl. uri_field)
    def new_instance(**args)
      required_args = (defined? required_arguments) ? required_arguments : {}
      required_args.delete(uri_field)
      args = required_args.merge(args)
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
