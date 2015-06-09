require_relative 'shared/base_resource_list_examples'

module Resync
  describe ResourceDump do
    it_behaves_like BaseResourceList
    it_behaves_like Augmented

    describe 'XML conversion' do
      describe '#from_xml' do
        it 'parses an XML string' do
          xml = File.read('spec/data/examples/example-17.xml')
          urlset = ResourceDump.load_from_xml(XML.element(xml))
          links = urlset.links
          expect(links.size).to eq(1)
          ln0 = links[0]
          expect(ln0.rel).to eq('up')
          expect(ln0.uri).to eq(URI('http://example.com/dataset1/capabilitylist.xml'))

          md = urlset.metadata
          expect(md.capability).to eq('resourcedump')
          expect(md.at_time).to be_time(Time.utc(2013, 1, 3, 9))
          expect(md.completed_time).to be_time(Time.utc(2013, 1, 3, 9, 4))

          urls = urlset.resources
          expect(urls.size).to eq(3)

          expected_lengths = [4765, 9875, 2298]
          expected_ats = [Time.utc(2013, 1, 3, 9), Time.utc(2013, 1, 3, 9, 1), Time.utc(2013, 1, 3, 9, 3)]
          expected_completeds = [Time.utc(2013, 1, 3, 9, 2), Time.utc(2013, 1, 3, 9, 3), Time.utc(2013, 1, 3, 9, 4)]

          (0..2).each do |i|
            url = urls[i]
            expect(url.uri).to eq(URI("http://example.com/resourcedump-part#{i + 1}.zip"))
            md = url.metadata
            expect(md.mime_type).to be_mime_type('application/zip')
            expect(md.length).to eq(expected_lengths[i])
            expect(md.at_time).to be_time(expected_ats[i])
            expect(md.completed_time).to be_time(expected_completeds[i])
            links = url.links
            expect(links.size).to eq(1)
            ln = links[0]
            expect(ln.rel).to eq('contents')
            expect(ln.uri).to eq(URI("http://example.com/resourcedump_manifest-part#{i + 1}.xml"))
            expect(ln.mime_type).to be_mime_type('application/xml')
          end
        end
      end

      describe '#save_to_xml' do
        it 'can round-trip to XML' do
          data = File.read('spec/data/examples/example-17.xml')
          dump = ResourceDump.load_from_xml(XML.element(data))
          xml = dump.save_to_xml
          expect(xml).to be_xml(data)
        end
      end
    end
  end
end
