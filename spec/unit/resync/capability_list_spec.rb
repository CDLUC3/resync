require_relative 'shared/base_resource_list_examples'
require_relative 'shared/uri_field_examples'

module Resync
  describe CapabilityList do

    # ------------------------------------------------------
    # Superclass conformance

    # Fixture overrides

    def required_arguments
      # TODO: Figure out if 'up' is mandatory for all resource lists, or just CapabilityList
      { links: [Link.new(rel: 'up', href: 'http://example.org/')] }
    end

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

      describe 'links' do
        it 'accepts a list of links' do
          # TODO: Figure out if 'up' is mandatory for all resource lists, or just CapabilityList
          links = [Link.new(rel: 'up', href: 'http://example.org/'), Link.new(rel: 'duplicates', href: 'http://example.com/')]
          list = CapabilityList.new(links: links)
          expect(list.links).to eq(links)
        end
      end

      describe 'source description' do
        it 'extracts the "up" link' do
          expected = 'http://example.org/desc.xml'
          links = [Link.new(rel: 'up', href: expected), Link.new(rel: 'duplicates', href: 'http://example.com/')]
          list = CapabilityList.new(links: links)
          expect(list.source_description).to eq(URI(expected))
        end

        it 'fails if no source description specified' do
          links = [Link.new(rel: 'describedby', href: 'http://example.org/'), Link.new(rel: 'duplicates', href: 'http://example.com/')]
          expect { CapabilityList.new(links: links) }.to raise_error(ArgumentError)
        end
      end

      describe 'resources' do
        it 'fails if a resource does not have a capability' do
          resources = [Resource.new(uri: 'http://example.com/dataset1/resourcelist.xml')]
          expect { CapabilityList.new(resources: resources, links: [Link.new(rel: 'up', href: 'http://example.org/')]) }.to raise_error(ArgumentError)
        end

        it 'fails if more than one resource is defined for the same capability' do
          resources = [1, 2].map { |n| Resource.new(uri: "http://example.com/list-#{n}.xml", metadata: Metadata.new(capability: 'resourcelist')) }
          expect { CapabilityList.new(resources: resources, links: [Link.new(rel: 'up', href: 'http://example.org/')]) }.to raise_error(ArgumentError)
        end
      end
    end

    describe 'resource_for' do
      it 'maps resources by capability' do
        resources = valid_resources
        capability_list = CapabilityList.new(resources: resources, links: [Link.new(rel: 'up', href: 'http://example.org/')])
        expect(capability_list.resource_for(capability: 'resourcelist')).to eq(resources[0])
        expect(capability_list.resource_for(capability: 'resourcedump')).to eq(resources[1])
        expect(capability_list.resource_for(capability: 'changelist')).to eq(resources[2])
        expect(capability_list.resource_for(capability: 'changedump')).to eq(resources[3])
      end
    end

    describe 'resources_for' do
      it 'maps resources by capability' do
        resources = valid_resources
        capability_list = CapabilityList.new(resources: resources, links: [Link.new(rel: 'up', href: 'http://example.org/')])
        expect(capability_list.resources_for(capability: 'resourcelist')).to eq([resources[0]])
        expect(capability_list.resources_for(capability: 'resourcedump')).to eq([resources[1]])
        expect(capability_list.resources_for(capability: 'changelist')).to eq([resources[2]])
        expect(capability_list.resources_for(capability: 'changedump')).to eq([resources[3]])
      end
    end

    describe 'XML conversion' do
      describe '#from_xml' do
        it 'parses an XML string' do
          data = File.read('spec/data/examples/example-13.xml')
          list = CapabilityList.load_from_xml(XML.element(data))

          links = list.links
          expect(links.size).to eq(2)
          ln0 = links[0]
          expect(ln0.rel).to eq('describedby')
          expect(ln0.href).to eq(URI('http://example.com/info_about_set1_of_resources.xml'))
          ln1 = links[1]
          expect(ln1.rel).to eq('up')
          expect(ln1.href).to eq(URI('http://example.com/resourcesync_description.xml'))

          md = list.metadata
          expect(md.capability).to eq('capabilitylist')

          urls = list.resources
          expect(urls.size).to eq(4)

          expected_capabilities = %w(resourcelist resourcedump changelist changedump)
          (0..3).each do |i|
            url = urls[i]
            capability = expected_capabilities[i]
            expect(url.uri).to eq(URI("http://example.com/dataset1/#{capability}.xml"))
            md = url.metadata
            expect(md.capability).to eq(capability)
          end
        end
      end

      describe '#save_to_xml' do
        it 'can round-trip to XML' do
          data = File.read('spec/data/examples/example-13.xml')
          list = CapabilityList.load_from_xml(XML.element(data))
          xml = list.save_to_xml
          expect(xml).to be_xml(data)
        end
      end
    end
  end

end
