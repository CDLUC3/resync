require 'spec_helper'

module Resync
  describe ChangeDump do
    describe '#new' do

      describe 'resources' do

        it 'accepts a list of resources' do
          resources = [Resource.new(uri: 'http://example.org/'), Resource.new(uri: 'http://example.com/')]
          resource_list = ChangeDump.new(resources: resources)
          expect(resource_list.resources).to eq(resources)
        end

        it 'defaults to an empty list if no resources are specified' do
          resource_list = ChangeDump.new
          expect(resource_list.resources).to eq([])
        end

        it 'sorts resources by lastmod' do
          resource0 = Resource.new(uri: 'http://example.org', lastmod: Time.utc(1997, 7, 16, 19, 20, 30.45))
          resource1 = Resource.new(uri: 'http://example.org', lastmod: Time.utc(1998, 7, 16, 19, 20, 30.45))
          misordered = [resource1, resource0]
          ordered = [resource0, resource1]
          change_list = ChangeDump.new(resources: misordered)
          expect(change_list.resources).to eq(ordered)
        end

        it 'sorts resources with lastmod before resourcese without' do
          resource0 = Resource.new(uri: 'http://example.org', lastmod: Time.utc(1997, 7, 16, 19, 20, 30.45))
          resource1 = Resource.new(uri: 'http://example.org', lastmod: Time.utc(1998, 7, 16, 19, 20, 30.45))
          resource2 = Resource.new(uri: 'http://example.com')
          misordered = [resource1, resource2, resource0]
          ordered = [resource0, resource1, resource2]
          change_list = ChangeDump.new(resources: misordered)
          expect(change_list.resources).to eq(ordered)
        end
      end

      describe 'metadata' do
        it 'accepts metadata' do
          metadata = Metadata.new(capability: 'changedump')
          resource_list = ChangeDump.new(metadata: metadata)
          expect(resource_list.metadata).to eq(metadata)
        end

        it 'defaults (otherwise empty) metadata with capability "changedump" if no metadata specified' do
          resource_list = ChangeDump.new
          metadata = resource_list.metadata
          expect(metadata.capability).to eq('changedump')
        end

        it 'fails if metadata does not have capability "changedump"' do
          expect { ChangeDump.new(metadata: Metadata.new) }.to raise_error(ArgumentError)
          expect { ChangeDump.new(metadata: Metadata.new(capability: 'resourcelist')) }.to raise_error(ArgumentError)
        end

        it 'requires from and until times (?)'
      end

    end
  end
end
