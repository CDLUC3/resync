require 'spec_helper'

module Resync
  describe Resource do
    describe '#new' do

      it 'accepts a URI' do
        uri = URI('http://example.org/')
        resource = Resource.new(uri: uri)
        expect(resource.uri).to eq(uri)
      end

      it 'accepts a string URI' do
        uri = 'http://example.org/'
        resource = Resource.new(uri: uri)
        expect(resource.uri).to eq(URI(uri))
      end

      it 'rejects an invalid URI' do
        invalid_url = 'I am not a valid URI'
        expect { Resource.new uri: invalid_url }.to raise_error(URI::InvalidURIError)
      end

    end
  end
end
