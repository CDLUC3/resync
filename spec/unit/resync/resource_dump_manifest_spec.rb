require_relative 'shared/base_resource_list_examples'

module Resync
  describe ResourceDumpManifest do
    it_behaves_like BaseResourceList

    describe 'links' do
      it_behaves_like LinkCollection
    end

    describe 'converts from XML' do
      describe '#from_xml' do
        it 'parses an XML string' do
          data = File.read('spec/data/examples/example-18.xml')
          urlset = ResourceDumpManifest.from_xml(data)

          links = urlset.links
          expect(links.size).to eq(1)
          ln0 = links[0]
          expect(ln0.rel).to eq('up')
          expect(ln0.href).to eq(URI('http://example.com/dataset1/capabilitylist.xml'))

          md = urlset.metadata
          expect(md.capability).to eq('resourcedump-manifest')
          expect(md.at_time).to be_time(Time.utc(2013, 1, 3, 9))
          expect(md.completed_time).to be_time(Time.utc(2013, 1, 3, 9, 2))

          urls = urlset.resources
          expect(urls.size).to eq(2)

          expected_lastmods = [Time.utc(2013, 1, 2, 13), Time.utc(2013, 1, 2, 14)]
          expected_hashes = [{ 'md5' => '1584abdf8ebdc9802ac0c6a7402c03b6' }, { 'md5' => '1e0d5cb8ef6ba40c99b14c0237be735e', 'sha-256' => '854f61290e2e197a11bc91063afce22e43f8ccc655237050ace766adc68dc784' }]
          expected_lengths = [8876, 14_599]
          expected_types = ['text/html', 'application/pdf']

          (0..1).each do |i|
            url = urls[i]
            expect(url.uri).to eq(URI("http://example.com/res#{i + 1}"))
            expect(url.modified_time).to be_time(expected_lastmods[i])
            md = url.metadata
            expect(md.hashes).to eq(expected_hashes[i])
            expect(md.length).to eq(expected_lengths[i])
            expect(md.mime_type).to be_mime_type(expected_types[i])
            expect(md.path).to eq("/resources/res#{i + 1}")
          end
        end
      end
    end
  end
end
