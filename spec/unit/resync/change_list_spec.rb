require 'spec_helper'

module Resync
  describe ChangeList do
    describe '#new' do

      describe 'resources' do

        # TODO: Should a change be modeled as an object distinct from a resource?

        it 'accepts a list of resources' do
          resources = [Resource.new(uri: 'http://example.org/'), Resource.new(uri: 'http://example.com/')]
          resource_list = ChangeList.new(resources: resources)
          expect(resource_list.resources).to eq(resources)
        end

        it 'defaults to an empty list if no resources are specified' do
          resource_list = ChangeList.new
          expect(resource_list.resources).to eq([])
        end
      end

      describe 'metadata' do
        it 'accepts metadata' do
          metadata = Metadata.new(capability: 'changelist')
          resource_list = ChangeList.new(metadata: metadata)
          expect(resource_list.metadata).to eq(metadata)
        end

        it 'defaults (otherwise empty) metadata with capability "changelist" if no metadata specified' do
          resource_list = ChangeList.new
          metadata = resource_list.metadata
          expect(metadata.capability).to eq('changelist')
        end

        it 'fails if metadata does not have capability "changelist"' do
          expect { ChangeList.new(metadata: Metadata.new) }.to raise_error(ArgumentError)
          expect { ChangeList.new(metadata: Metadata.new(capability: 'resourcelist')) }.to raise_error(ArgumentError)
        end

        it 'requires from and until times (?)'
      end

    end
  end
end
