require_relative 'shared/sorted_list_examples'

module Resync
  describe ChangeList do
    it_behaves_like SortedResourceList

    describe 'converts from XML' do
      describe '#from_xml' do
        it 'parses an XML string' do
          Change = Types::Change

          xml = File.read('spec/data/examples/example-27.xml')
          list = ChangeList.from_xml(xml)

          links = list.links
          expect(links.size).to eq(1)
          ln0 = links[0]
          expect(ln0.rel).to eq('up')
          expect(ln0.href).to eq(URI('http://example.com/dataset1/capabilitylist.xml'))

          md = list.metadata
          expect(md.capability).to eq('changelist')
          expect(md.from_time).to be_time(Time.utc(2013, 1, 3))

          urls = list.resources
          expect(urls.size).to eq(2)

          url0 = urls[0]
          expect(url0.uri).to eq(URI('http://example.com/res4'))
          expect(url0.modified_time).to be_time(Time.utc(2013, 1, 3, 17))
          md0 = url0.metadata
          expect(md0.change).to be(Change::UPDATED)
          expect(md0.hashes).to eq('sha-256' => 'f4OxZX_x_DFGFDgghgdfb6rtSx-iosjf6735432nklj')
          expect(md0.length).to eq(56_778)
          expect(md0.mime_type).to be_mime_type('application/json')
          lns0 = url0.links
          expect(lns0.size).to eq(1)
          ln0 = lns0[0]
          expect(ln0.rel).to(eq('http://www.openarchives.org/rs/terms/patch'))
          expect(ln0.href).to(eq(URI('http://example.com/res4-json-patch')))
          expect(ln0.modified_time).to(eq(Time.utc(2013, 1, 3, 17)))
          expect(ln0.hashes).to(eq('sha-256' => 'y66dER_t_HWEIKpesdkeb7rtSc-ippjf9823742opld'))
          expect(ln0.length).to(eq(73))
          expect(ln0.mime_type).to(be_mime_type('application/json-patch'))

          url1 = urls[1]
          expect(url1.uri).to eq(URI('http://example.com/res5-full.tiff'))
          expect(url1.modified_time).to be_time(Time.utc(2013, 1, 3, 18))
          md1 = url1.metadata
          expect(md1.change).to be(Change::UPDATED)
          expect(md1.hashes).to eq('sha-256' => 'f4OxZX_x_FO5LcGBSKHWXfwtSx-j1ncoSt3SABJtkGk')
          expect(md1.length).to eq(9_788_456_778)
          expect(md1.mime_type).to be_mime_type('image/tiff')
          lns1 = url1.links
          expect(lns1.size).to eq(1)
          ln1 = lns1[0]
          expect(ln1.rel).to(eq('http://www.openarchives.org/rs/terms/patch'))
          expect(ln1.href).to(eq(URI('http://example.com/res5-diff')))
          expect(ln1.modified_time).to(eq(Time.utc(2013, 1, 3, 18)))
          expect(ln1.hashes).to(eq('sha-256' => 'h986gT_t_87HTkjHYE76G558hY-jdfgy76t55sadJUYT'))
          expect(ln1.length).to(eq(4533))
          expect(ln1.mime_type).to(be_mime_type('application/x-tiff-diff'))
        end
      end
    end

  end
end
