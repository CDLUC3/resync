require 'spec_helper'

# TODO: Use RSpec shared examples to test subclasses
module Resync

  class MockSortedList < SortedListBase
    CAPABILITY = 'mocksortedlist'
  end

  # TODO: Use RSpec shared examples to avoid duplicating list_base_spec
  describe SortedListBase do
    describe '#new' do

      describe 'resources' do

        it 'accepts a list of resources' do
          resources = [Resource.new(uri: 'http://example.org/'), Resource.new(uri: 'http://example.com/')]
          list = MockSortedList.new(resources: resources)
          expect(list.resources).to eq(resources)
        end

        it 'defaults to an empty list if no resources are specified' do
          list = MockSortedList.new
          expect(list.resources).to eq([])
        end

        it 'sorts resources by lastmod' do
          resource0 = Resource.new(uri: 'http://example.org', lastmod: Time.utc(1997, 7, 16, 19, 20, 30.45))
          resource1 = Resource.new(uri: 'http://example.org', lastmod: Time.utc(1998, 7, 16, 19, 20, 30.45))
          misordered = [resource1, resource0]
          ordered = [resource0, resource1]
          list = MockSortedList.new(resources: misordered)
          expect(list.resources).to eq(ordered)
        end

        it 'sorts resources with lastmod before resources without' do
          resource0 = Resource.new(uri: 'http://example.org', lastmod: Time.utc(1997, 7, 16, 19, 20, 30.45))
          resource1 = Resource.new(uri: 'http://example.org', lastmod: Time.utc(1998, 7, 16, 19, 20, 30.45))
          resource2 = Resource.new(uri: 'http://example.com')
          misordered = [resource1, resource2, resource0]
          ordered = [resource0, resource1, resource2]
          list = MockSortedList.new(resources: misordered)
          expect(list.resources).to eq(ordered)
        end
      end

      describe 'metadata' do
        it 'accepts metadata' do
          metadata = Metadata.new(capability: MockSortedList::CAPABILITY)
          list = MockSortedList.new(metadata: metadata)
          expect(list.metadata).to eq(metadata)
        end

        it 'defaults (otherwise empty) metadata with capability CAPABILITY if no metadata specified' do
          list = MockSortedList.new
          metadata = list.metadata
          expect(metadata.capability).to eq(MockSortedList::CAPABILITY)
        end

        it 'fails if metadata does not have capability "changelist"' do
          expect { MockSortedList.new(metadata: Metadata.new) }.to raise_error(ArgumentError)
          expect { MockSortedList.new(metadata: Metadata.new(capability: 'resourcelist')) }.to raise_error(ArgumentError)
        end

        it 'requires from and until times (?)'
      end

    end
  end
end
