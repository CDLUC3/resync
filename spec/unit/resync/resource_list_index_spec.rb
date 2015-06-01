require_relative 'shared/base_resource_list_examples'

module Resync
  describe ResourceListIndex do
    it_behaves_like BaseResourceList

    describe 'links' do
      it_behaves_like Augmented
    end

    describe 'XML conversion' do
      describe '#from_xml' do
        it 'parses an XML string' do
          data = XML.element(File.read('spec/data/examples/example-15.xml'))
          sitemapindex = ResourceListIndex.load_from_xml(data)

          links = sitemapindex.links
          expect(links.size).to eq(1)
          ln0 = links[0]
          expect(ln0.rel).to eq('up')
          expect(ln0.uri).to eq(URI('http://example.com/dataset1/capabilitylist.xml'))

          md = sitemapindex.metadata
          expect(md.capability).to eq('resourcelist')
          expect(md.at_time).to be_time(Time.utc(2013, 1, 3, 9))
          expect(md.completed_time).to be_time(Time.utc(2013, 1, 3, 9, 10))

          sitemaps = sitemapindex.resources
          expect(sitemaps.size).to eq(3)

          expected_times = [Time.utc(2013, 1, 3, 9), Time.utc(2013, 1, 3, 9, 3), Time.utc(2013, 1, 3, 9, 7)]
          (0..2).each do |i|
            sitemap = sitemaps[i]
            expect(sitemap.uri).to eq(URI("http://example.com/resourcelist#{i + 1}.xml"))
            md = sitemap.metadata
            expect(md.at_time).to be_time(expected_times[i])
          end
        end
      end

      describe '#save_to_xml' do
        it 'can round-trip to XML' do
          data = XML.element(File.read('spec/data/examples/example-15.xml'))
          list = ResourceListIndex.load_from_xml(XML.element(data), mapping: :sitemapindex)
          xml = list.save_to_xml
          expect(xml).to be_xml(data)
        end
      end

    end

  end
end
