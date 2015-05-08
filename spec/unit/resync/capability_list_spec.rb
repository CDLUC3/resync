require 'spec_helper'

module Resync
  describe CapabilityList do
    describe '#new' do

      describe 'source description' do
        it 'accepts a URI' do
          uri = URI('http://example.org/')
          capability_list = CapabilityList.new(source_description: uri)
          expect(capability_list.source_description).to eq(uri)
        end

        it 'accepts a string URI' do
          uri = 'http://example.org/'
          capability_list = CapabilityList.new(source_description: uri)
          expect(capability_list.source_description).to eq(URI(uri))
        end

        it 'rejects an invalid URI' do
          invalid_url = 'I am not a valid URI'
          expect { CapabilityList.new source_description: invalid_url }.to raise_error(URI::InvalidURIError)
        end

        it 'requires a URI' do
          expect { CapabilityList.new }.to raise_error(ArgumentError)
        end
      end

      describe 'metadata' do
        it 'accepts metadata' do
          metadata = Metadata.new(capability: 'capabilitylist')
          capability_list = CapabilityList.new(metadata: metadata, source_description: 'http://example.org/')
          expect(capability_list.metadata).to eq(metadata)
        end

        it 'defaults (otherwise empty) metadata with capability "capabilitylist" if no metadata specified' do
          capability_list = CapabilityList.new(source_description: 'http://example.org/')
          metadata = capability_list.metadata
          expect(metadata.capability).to eq('capabilitylist')
        end

        it 'fails if metadata does not have capability "capabilitylist"' do
          expect { CapabilityList.new(metadata: Metadata.new, source_description: 'http://example.org/') }.to raise_error(ArgumentError)
          expect { CapabilityList.new(metadata: Metadata.new(capability: 'changelist'), source_description: 'http://example.org/') }.to raise_error(ArgumentError)
        end
      end

      describe 'resources' do
        it 'accepts a list of resources' do
          resources = [
            Resource.new(
              uri: 'http://example.com/dataset1/resourcelist.xml',
              metadata: Metadata.new(capability: 'resourcelist')
            ),
            Resource.new(
              uri: 'http://example.com/dataset1/resourcedump.xml',
              metadata: Metadata.new(capability: 'resourcedump')
            ),
            Resource.new(
              uri: 'http://example.com/dataset1/changelist.xml',
              metadata: Metadata.new(capability: 'changelist')
            ),
            Resource.new(
              uri: 'http://example.com/dataset1/changedump.xml',
              metadata: Metadata.new(capability: 'changedump')
            )
          ]

          capability_list = CapabilityList.new(resources: resources, source_description: 'http://example.org/')
          expect(capability_list.resources).to eq(resources)
        end

        it 'defaults to an empty list if no resources specified' do
          capability_list = CapabilityList.new(source_description: 'http://example.org/')
          expect(capability_list.resources).to eq([])
        end

        it 'fails if a resource does not have a capability' do
          resources = [Resource.new(uri: 'http://example.com/dataset1/resourcelist.xml')]
          expect { CapabilityList.new(resources: resources, source_description: 'http://example.org/') }.to raise_error(ArgumentError)
        end

        it 'fails if more than one resource is defined for the same capability' do
          resources = [
            Resource.new(
              uri: 'http://example.com/dataset1/resourcelist.xml',
              metadata: Metadata.new(capability: 'resourcelist')
            ),
            Resource.new(
              uri: 'http://example.com/dataset1/resourcelist-2.xml',
              metadata: Metadata.new(capability: 'resourcelist')
            )
          ]
          expect { CapabilityList.new(resources: resources, source_description: 'http://example.org/') }.to raise_error(ArgumentError)
        end
      end

    end

    describe 'resource_for' do
      it 'maps resources by capability' do
        resources = [
          Resource.new(
            uri: 'http://example.com/dataset1/resourcelist.xml',
            metadata: Metadata.new(capability: 'resourcelist')
          ),
          Resource.new(
            uri: 'http://example.com/dataset1/resourcedump.xml',
            metadata: Metadata.new(capability: 'resourcedump')
          ),
          Resource.new(
            uri: 'http://example.com/dataset1/changelist.xml',
            metadata: Metadata.new(capability: 'changelist')
          ),
          Resource.new(
            uri: 'http://example.com/dataset1/changedump.xml',
            metadata: Metadata.new(capability: 'changedump')
          )
        ]

        capability_list = CapabilityList.new(resources: resources, source_description: 'http://example.org/')
        expect(capability_list.resource_for(capability: 'resourcelist')).to eq(resources[0])
        expect(capability_list.resource_for(capability: 'resourcedump')).to eq(resources[1])
        expect(capability_list.resource_for(capability: 'changelist')).to eq(resources[2])
        expect(capability_list.resource_for(capability: 'changedump')).to eq(resources[3])
      end
    end

  end
end
