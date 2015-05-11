require_relative 'shared/base_resource_list_examples'

module Resync
  describe CapabilityList do

    # ------------------------------------------------------
    # Superclass conformance

    # Fixture overrides

    def new_list_override(**args)
      CapabilityList.new(source_description: 'http://example.org/', **args)
    end

    def resource_list_override
      [Resource.new(uri: 'http://example.com/dataset1/resourcelist.xml', metadata: Metadata.new(capability: 'resourcelist')),
       Resource.new(uri: 'http://example.com/dataset1/resourcedump.xml', metadata: Metadata.new(capability: 'resourcedump')),
       Resource.new(uri: 'http://example.com/dataset1/changelist.xml', metadata: Metadata.new(capability: 'changelist')),
       Resource.new(uri: 'http://example.com/dataset1/changedump.xml', metadata: Metadata.new(capability: 'changedump'))]
    end

    # Tests

    it_behaves_like BaseResourceList

    # ------------------------------------------------------
    # Tests

    describe '#new' do
      # TODO: Find a way to share this with resource_spec 'uri'
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

      describe 'resources' do
        it 'fails if a resource does not have a capability' do
          resources = [Resource.new(uri: 'http://example.com/dataset1/resourcelist.xml')]
          expect { CapabilityList.new(resources: resources, source_description: 'http://example.org/') }.to raise_error(ArgumentError)
        end

        it 'fails if more than one resource is defined for the same capability' do
          resources = [1, 2].map { |n| Resource.new(uri: "http://example.com/list-#{n}.xml", metadata: Metadata.new(capability: 'resourcelist')) }
          expect { CapabilityList.new(resources: resources, source_description: 'http://example.org/') }.to raise_error(ArgumentError)
        end
      end
    end

    describe 'resource_for' do
      it 'maps resources by capability' do
        resources = resource_list_override
        capability_list = CapabilityList.new(resources: resources, source_description: 'http://example.org/')
        expect(capability_list.resource_for(capability: 'resourcelist')).to eq(resources[0])
        expect(capability_list.resource_for(capability: 'resourcedump')).to eq(resources[1])
        expect(capability_list.resource_for(capability: 'changelist')).to eq(resources[2])
        expect(capability_list.resource_for(capability: 'changedump')).to eq(resources[3])
      end
    end

  end

end
