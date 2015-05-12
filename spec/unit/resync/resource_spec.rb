require 'spec_helper'
require_relative 'shared/uri_field_examples'
require_relative 'shared/link_collection_examples'

module Resync
  describe Resource do
    describe '#new' do

      describe 'uri' do
        def uri_field; :uri; end # rubocop:disable Style/SingleLineMethods
        it_behaves_like 'a URI field'
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

      describe 'links' do
        def required_arguments
          { uri: 'http://example.org' }
        end
        it_behaves_like LinkCollection
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
