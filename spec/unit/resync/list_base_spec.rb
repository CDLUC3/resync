require 'spec_helper'

# TODO: Use RSpec shared examples to test subclasses
module Resync
  class MockList < ListBase
    CAPABILITY = 'mocklist'
  end

  describe ListBase do

    describe '#new' do

      describe 'resources' do
        it 'accepts a list of resources' do
          resources = [Resource.new(uri: 'http://example.org/'), Resource.new(uri: 'http://example.com/')]
          list = MockList.new(resources: resources)
          expect(list.resources).to eq(resources)
        end

        it 'defaults to an empty list if no resources are specified' do
          list = MockList.new
          expect(list.resources).to eq([])
        end
      end

      describe 'metadata' do
        it 'accepts metadata' do
          metadata = Metadata.new(capability: MockList::CAPABILITY)
          list = MockList.new(metadata: metadata)
          expect(list.metadata).to eq(metadata)
        end

        it 'defaults (otherwise empty) metadata with capability CAPABILITY if no metadata specified' do
          list = MockList.new
          metadata = list.metadata
          expect(metadata.capability).to eq(MockList::CAPABILITY)
        end

        it 'fails if metadata does not have capability CAPABILITY' do
          expect { MockList.new(metadata: Metadata.new) }.to raise_error(ArgumentError)
          expect { MockList.new(metadata: Metadata.new(capability: 'changelist')) }.to raise_error(ArgumentError)
        end
      end

    end

  end
end
