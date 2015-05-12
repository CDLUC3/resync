require_relative 'shared/base_resource_list_examples'
require_relative 'shared/uri_field_examples'

module Resync
  describe CapabilityList do

    # ------------------------------------------------------
    # Superclass conformance

    # Fixture overrides

    def required_arguments; { source_description: 'http://example.org' }; end # rubocop:disable Style/SingleLineMethods

    def valid_resources
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

      describe 'source description' do
        def uri_field; :source_description; end # rubocop:disable Style/SingleLineMethods
        it_behaves_like 'a URI field'
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
        resources = valid_resources
        capability_list = CapabilityList.new(resources: resources, source_description: 'http://example.org/')
        expect(capability_list.resource_for(capability: 'resourcelist')).to eq(resources[0])
        expect(capability_list.resource_for(capability: 'resourcedump')).to eq(resources[1])
        expect(capability_list.resource_for(capability: 'changelist')).to eq(resources[2])
        expect(capability_list.resource_for(capability: 'changedump')).to eq(resources[3])
      end
    end

  end

end
