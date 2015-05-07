require 'spec_helper'

module Resync
  describe ResourceDump do

    describe '#new' do

      describe 'resources' do
        it 'accepts a list of resources' do
          resources = [Resource.new(uri: 'http://example.org/'), Resource.new(uri: 'http://example.com/')]
          resource_list = ResourceDump.new(resources: resources)
          expect(resource_list.resources).to eq(resources)
        end

        it 'defaults to an empty list if no resources are specified' do
          resource_list = ResourceDump.new
          expect(resource_list.resources).to eq([])
        end
      end

      describe 'metadata' do
        it 'accepts metadata' do
          metadata = Metadata.new(capability: 'resourcedump')
          resource_list = ResourceDump.new(metadata: metadata)
          expect(resource_list.metadata).to eq(metadata)
        end

        it 'defaults (otherwise empty) metadata with capability "resourcedump" if no metadata specified' do
          resource_list = ResourceDump.new
          metadata = resource_list.metadata
          expect(metadata.capability).to eq('resourcedump')
        end

        it 'fails if metadata does not have capability "resourcedump"' do
          expect { ResourceDump.new(metadata: Metadata.new) }.to raise_error(ArgumentError)
          expect { ResourceDump.new(metadata: Metadata.new(capability: 'changelist')) }.to raise_error(ArgumentError)
        end
      end

    end

  end
end
