require 'spec_helper'

module Resync
  describe ResourceList do

    describe '#new' do

      describe 'resources' do
        it 'accepts a list of resources' do
          resources = [Resource.new(uri: 'http://example.org/'), Resource.new(uri: 'http://example.com/')]
          resource_list = ResourceList.new(resources: resources)
          expect(resource_list.resources).to eq(resources)
        end

        it 'defaults to an empty list if no resources are specified' do
          resource_list = ResourceList.new
          expect(resource_list.resources).to eq([])
        end
      end

      describe 'metadata' do
        it 'accepts metadata' do
          metadata = Metadata.new(capability: 'resourcelist')
          resource_list = ResourceList.new(metadata: metadata)
          expect(resource_list.metadata).to eq(metadata)
        end

        it 'defaults (otherwise empty) metadata with capability "resourcelist" if no metadata specified' do
          resource_list = ResourceList.new
          metadata = resource_list.metadata
          expect(metadata.capability).to eq('resourcelist')
        end

        it 'fails if metadata does not have capability "resourcelist"' do
          expect { ResourceList.new(metadata: Metadata.new) }.to raise_error(ArgumentError)
          expect { ResourceList.new(metadata: Metadata.new(capability: 'changelist')) }.to raise_error(ArgumentError)
        end
      end

    end

  end
end
