require_relative 'shared/base_change_list_examples'

module Resync
  describe ChangeDumpManifest do
    it_behaves_like BaseChangeList
    describe 'XML conversion' do
      describe '#from_xml' do
        it 'parses an XML string' do

          xml = File.read('spec/data/examples/example-23.xml')
          urlset = ChangeDumpManifest.load_from_xml(XML.element(xml))

          links = urlset.links
          expect(links.size).to eq(1)
          ln0 = links[0]
          expect(ln0.rel).to eq('up')
          expect(ln0.uri).to eq(URI('http://example.com/dataset1/capabilitylist.xml'))

          md = urlset.metadata
          expect(md.capability).to eq('changedump-manifest')
          expect(md.from_time).to be_time(Time.utc(2013, 1, 2))
          expect(md.until_time).to be_time(Time.utc(2013, 1, 3))

          urls = urlset.resources
          expect(urls.size).to eq(4)

          expected_filenames = %w(res7 res9 res5 res7)
          expected_extensions = %w(html pdf tiff html)
          expected_lastmods = [
            Time.utc(2013, 1, 2, 12),
            Time.utc(2013, 1, 2, 13),
            Time.utc(2013, 1, 2, 19),
            Time.utc(2013, 1, 2, 20)
          ]
          expected_changes = [Types::Change::CREATED, Types::Change::UPDATED, Types::Change::DELETED, Types::Change::UPDATED]
          expected_hashes = [
            { 'md5' => '1c1b0e264fa9b7e1e9aa6f9db8d6362b' },
            { 'md5' => 'f906610c3d4aa745cb2b986f25b37c5a' },
            {},
            { 'md5' => '0988647082c8bc51778894a48ec3b576' }
          ]
          expected_lengths = [4339, 38_297, nil, 5426]
          expected_types = [
            'text/html',
            'application/pdf',
            nil,
            'text/html'
          ]
          expected_paths = ['/changes/res7.html', '/changes/res9.pdf', nil, '/changes/res7-v2.html']

          (0..3).each do |i|
            url = urls[i]
            expect(url.uri).to eq(URI("http://example.com/#{expected_filenames[i]}.#{expected_extensions[i]}"))
            expect(url.modified_time).to be_time(expected_lastmods[i])
            md = url.metadata
            expect(md.change).to eq(expected_changes[i])
            expect(md.hashes).to eq(expected_hashes[i])
            expect(md.length).to eq(expected_lengths[i])
            expect(md.mime_type).to be_mime_type(expected_types[i])
            expect(md.path).to eq(expected_paths[i])
          end
        end
      end

      describe '#save_to_xml' do
        it 'can round-trip to XML' do
          data = File.read('spec/data/examples/example-23.xml')
          manifest = ChangeDumpManifest.load_from_xml(XML.element(data))
          xml = manifest.save_to_xml
          expect(xml).to be_xml(data)
        end
      end
    end
  end
end
