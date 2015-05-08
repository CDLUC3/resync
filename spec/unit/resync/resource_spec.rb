require 'spec_helper'

module Resync
  describe Resource do
    describe '#new' do

      describe 'uri' do

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

      describe 'lastmod' do
        it 'accepts a lastmod timestamp' do
          lastmod = Time.utc(1997, 7, 16, 19, 20, 30.45)
          resource = Resource.new(uri: 'http://example.org', lastmod: lastmod)
          expect(resource.lastmod).to be_time(lastmod)
        end

        it 'defaults to nil if no lastmod timestamp specified' do
          resource = Resource.new(uri: 'http://example.org')
          expect(resource.lastmod).to be_nil
        end
      end

      describe 'metadata' do

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

    describe 'capability' do
      it 'extracts the capability from the metadata' do
        md = Metadata.new(capability: 'changelist')
        resource = Resource.new(uri: 'http://example.org', metadata: md)
        expect(resource.capability).to eq('changelist')
      end

      it 'returns nil if no metadata was specified' do
        resource = Resource.new(uri: 'http://example.org')
        expect(resource.capability).to be_nil
      end
    end

  end
end
