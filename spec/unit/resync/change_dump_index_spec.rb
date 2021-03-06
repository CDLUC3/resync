require_relative 'shared/base_change_index_examples'

module Resync
  describe ChangeDumpIndex do
    it_behaves_like BaseChangeIndex

    describe 'XML conversion' do
      describe '#from_xml' do
        it 'parses an XML string' do

          xml = File.read('spec/data/changedump-index.xml')
          sitemapindex = ChangeDumpIndex.load_from_xml(XML.element(xml))

          links = sitemapindex.links
          expect(links.size).to eq(1)
          ln0 = links[0]
          expect(ln0.rel).to eq('up')
          expect(ln0.uri).to eq(URI('http://example.com/dataset1/capabilitylist.xml'))

          md = sitemapindex.metadata
          expect(md.capability).to eq('changedump')
          expect(md.from_time).to be_time(Time.utc(2013, 1, 1))

          sitemaps = sitemapindex.resources
          expect(sitemaps.size).to eq(3)

          expected_froms = [Time.utc(2013, 1, 1), Time.utc(2013, 1, 2), Time.utc(2013, 1, 3)]
          expected_untils = [Time.utc(2013, 1, 2), Time.utc(2013, 1, 3), nil]
          (0..2).each do |i|
            sitemap = sitemaps[i]
            expect(sitemap.uri).to eq(URI("http://example.com/2013010#{i + 1}-changedump.xml"))
            md = sitemap.metadata
            expect(md.from_time).to be_time(expected_froms[i])
            expect(md.until_time).to be_time(expected_untils[i])
          end
        end
      end

      describe '#save_to_xml' do
        it 'can round-trip to XML' do
          data = File.read('spec/data/changedump-index.xml')
          list = ChangeDumpIndex.load_from_xml(XML.element(data))
          xml = list.save_to_xml
          expect(xml).to be_xml(data)
        end
      end
    end
  end
end
