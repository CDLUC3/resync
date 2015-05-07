require 'spec_helper'

module Resync
  describe Resource do
    describe '#new' do

      describe '@uri' do

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

        it 'requires a URI' do
          expect { Resource.new }.to raise_error(ArgumentError)
        end

      end

      describe '@metadata' do

        it 'accepts metadata' do
          md = Metadata.new
          resource = Resource.new(uri: 'http://example.org', metadata: md)
          expect(resource.metadata).to eq(md)
        end

        it 'defaults to nil if metadata not specified' do
          resource = Resource.new(uri: 'http://example.org')
          expect(resource.metadata).to be_nil
        end

      end

    end
  end
end
