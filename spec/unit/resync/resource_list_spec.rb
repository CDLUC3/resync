require_relative 'shared/base_resource_list_examples'

module Resync
  describe ResourceList do
    it_behaves_like BaseResourceList

    describe 'links' do
      it_behaves_like LinkCollection
    end

    describe 'converts from XML' do
      describe '#from_xml' do
        it 'parses an XML string' do
          xml = File.read('spec/data/examples/example-16.xml')
          list = ResourceList.from_xml(xml)
          links = list.links
          expect(links.size).to eq(2)
          ln0 = links[0]
          expect(ln0.rel).to eq('up')
          expect(ln0.href).to eq(URI('http://example.com/dataset1/capabilitylist.xml'))
          ln1 = links[1]
          expect(ln1.rel).to eq('index')
          expect(ln1.href).to eq(URI('http://example.com/dataset1/resourcelist-index.xml'))

          md = list.metadata
          expect(md.capability).to eq('resourcelist')
          expect(md.at_time).to be_time(Time.utc(2013, 1, 3, 9))

          urls = list.resources
          expect(urls.size).to eq(2)

          expected_lastmods = [Time.utc(2013, 1, 2, 13), Time.utc(2013, 1, 2, 14)]
          expected_hashes = [{ 'md5' => '1584abdf8ebdc9802ac0c6a7402c8753' }, { 'md5' => '4556abdf8ebdc9802ac0c6a7402c9881' }]
          expected_lengths = [4385, 883]
          expected_types = ['application/pdf', 'image/png']

          (0..1).each do |i|
            url = urls[i]
            expect(url.uri).to eq(URI("http://example.com/res#{i + 3}"))
            expect(url.modified_time).to be_time(expected_lastmods[i])
            md = url.metadata
            expect(md.hashes).to eq(expected_hashes[i])
            expect(md.length).to eq(expected_lengths[i])
            expect(md.mime_type).to be_mime_type(expected_types[i])
          end
        end
      end
    end

  end
end
