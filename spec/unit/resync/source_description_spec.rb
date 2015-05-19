require 'spec_helper'
require_relative 'shared/base_resource_list_examples'
require_relative 'shared/link_collection_examples'

module Resync
  describe SourceDescription do
    it_behaves_like BaseResourceList

    describe 'links' do
      it_behaves_like Augmented
    end

    describe 'XML conversion' do
      describe '#from_xml' do
        it 'parses an XML string' do
          data = File.read('spec/data/examples/example-12.xml')
          list = SourceDescription.from_xml(data)

          links = list.links
          expect(links.size).to eq(1)
          link = links[0]
          expect(link.rel).to eq('describedby')
          expect(link.href).to eq(URI('http://example.com/info_about_source.xml'))

          md = list.metadata
          expect(md.capability).to eq('description')

          urls = list.resources
          expect(urls.size).to eq(3)

          (0..2).each do |i|
            url = urls[i]
            expect(url.uri).to eq(URI("http://example.com/capabilitylist#{i + 1}.xml"))
            md = url.metadata
            expect(md.capability).to eq('capabilitylist')
            links = url.links
            expect(links.size).to eq(1)
            link = links[0]
            expect(link.rel).to eq('describedby')
            expect(link.href).to eq(URI("http://example.com/info_about_set#{i + 1}_of_resources.xml"))
          end
        end
      end

      describe '#save_to_xml' do
        it 'can round-trip to XML' do
          data = File.read('spec/data/examples/example-12.xml')
          list = SourceDescription.from_xml(data)
          xml = list.save_to_xml
          expect(xml).to be_xml(data)
        end
      end
    end
  end
end
