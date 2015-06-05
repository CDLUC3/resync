require_relative 'shared/sorted_list_examples'

module Resync
  describe ChangeDump do
    it_behaves_like SortedResourceList

    it 'allows filtering by time range' do
      fail 'test not implemented'
    end

    describe 'XML conversion' do
      describe '#from_xml' do
        it 'parses an XML string' do
          xml = File.read('spec/data/examples/example-22.xml')
          urlset = ChangeDump.load_from_xml(XML.element(xml))
          links = urlset.links
          expect(links.size).to eq(1)
          ln0 = links[0]
          expect(ln0.rel).to eq('up')
          expect(ln0.uri).to eq(URI('http://example.com/dataset1/capabilitylist.xml'))

          md = urlset.metadata
          expect(md.capability).to eq('changedump')
          expect(md.from_time).to be_time(Time.utc(2013, 1, 1))

          urls = urlset.resources
          expect(urls.size).to eq(3)

          expected_lastmods = [
            Time.utc(2013, 1, 1, 23, 59, 59),
            Time.utc(2013, 1, 2, 23, 59, 59),
            Time.utc(2013, 1, 3, 23, 59, 59)
          ]
          expected_lengths = [3109, 6629, 8124]

          (0..2).each do |i|
            url = urls[i]
            expect(url.uri).to eq(URI("http://example.com/2013010#{i + 1}-changedump.zip"))
            expect(url.modified_time).to eq(expected_lastmods[i])
            md = url.metadata
            expect(md.mime_type).to be_mime_type('application/zip')
            expect(md.length).to eq(expected_lengths[i])
            expect(md.from_time).to be_time(Time.utc(2013, 1, i + 1))
            expect(md.until_time).to be_time(Time.utc(2013, 1, i + 2))
            links = url.links
            expect(links.size).to eq(1)
            ln = links[0]
            expect(ln.rel).to eq('contents')
            expect(ln.uri).to eq(URI("http://example.com/2013010#{i + 1}-changedump-manifest.xml"))
            expect(ln.mime_type).to be_mime_type('application/xml')
          end
        end
      end

      describe '#save_to_xml' do
        it 'can round-trip to XML' do
          data = File.read('spec/data/examples/example-22.xml')
          dump = ChangeDump.load_from_xml(XML.element(data))
          xml = dump.save_to_xml
          expect(xml).to be_xml(data)
        end
      end
    end
  end
end
