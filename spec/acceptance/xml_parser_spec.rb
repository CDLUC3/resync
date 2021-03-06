require 'spec_helper'

module Resync

  describe XMLParser do

    it 'parses example 1' do
      data = File.read('spec/data/examples/example-1.xml')
      urlset = XMLParser.parse(data)
      expect(urlset).to be_a(ResourceList)

      md = urlset.metadata
      expect(md).not_to be_nil
      expect(md.capability).to eq('resourcelist')
      expect(md.at_time).to be_time(Time.utc(2013, 1, 3, 9))

      urls = urlset.resources
      expect(urls.size).to eq(2)

      url0 = urls[0]
      expect(url0.uri).to eq(URI('http://example.com/res1'))

      url1 = urls[1]
      expect(url1.uri).to eq(URI('http://example.com/res2'))
    end

    it 'parses example 2' do
      data = File.read('spec/data/examples/example-2.xml')
      urlset = XMLParser.parse(data)
      expect(urlset).to be_a(ResourceList)

      md = urlset.metadata
      expect(md).not_to be_nil
      expect(md.capability).to eq('resourcelist')
      expect(md.at_time).to be_time(Time.utc(2013, 1, 3, 9))

      urls = urlset.resources
      expect(urls.size).to eq(2)

      url0 = urls[0]
      expect(url0.uri).to eq(URI('http://example.com/res1'))
      expect(url0.modified_time).to be_time(Time.utc(2013, 1, 2, 13))
      md0 = url0.metadata
      expect(md0).not_to be_nil
      expect(md0.hashes).to eq('md5' => '1584abdf8ebdc9802ac0c6a7402c03b6')
      lns0 = urls[0].links
      expect(lns0.size).to eq(0)

      url1 = urls[1]
      expect(url1.uri).to eq(URI('http://example.com/res2'))
      expect(url1.modified_time).to be_time(Time.utc(2013, 1, 2, 14))
      md1 = url1.metadata
      expect(md1).not_to be_nil
      expect(md1.hashes).to eq('md5' => '1e0d5cb8ef6ba40c99b14c0237be735e')
      lns1 = urls[1].links
      expect(lns1.size).to eq(1)
      ln1 = lns1[0]
      expect(ln1.rel).to eq('duplicate')
      expect(ln1.uri).to eq(URI('http://mirror.example.com/res2'))
    end

    it 'parses example 3' do
      data = File.read('spec/data/examples/example-3.xml')
      urlset = XMLParser.parse(data)
      expect(urlset).to be_a(ChangeList)

      urls = urlset.resources
      expect(urls.size).to eq(2)
      url0 = urls[0]
      expect(url0.uri).to eq(URI('http://example.com/res2.pdf'))
      expect(url0.modified_time).to be_time(Time.utc(2013, 1, 2, 13))
      md0 = url0.metadata
      expect(md0).not_to be_nil
      expect(md0.change).to be(Resync::Types::Change::UPDATED)

      url1 = urls[1]
      expect(url1.uri).to eq(URI('http://example.com/res3.tiff'))
      expect(url1.modified_time).to be_time(Time.utc(2013, 1, 2, 18))
      md1 = url1.metadata
      expect(md1).not_to be_nil
      expect(md1.change).to be(Resync::Types::Change::DELETED)
    end

    it 'parses example 4' do
      data = File.read('spec/data/examples/example-4.xml')
      urlset = XMLParser.parse(data)
      expect(urlset).to be_a(ResourceDump)

      md = urlset.metadata
      expect(md.capability).to eq('resourcedump')
      expect(md.at_time).to be_time(Time.utc(2013, 1, 3, 9))

      urls = urlset.resources
      expect(urls.size).to eq(1)

      url0 = urls[0]
      expect(url0.uri).to eq(URI('http://example.com/resourcedump.zip'))
      expect(url0.modified_time).to be_time(Time.utc(2013, 1, 3, 9))
    end

    it 'parses example 5' do
      data = File.read('spec/data/examples/example-5.xml')
      urlset = XMLParser.parse(data)
      expect(urlset).to be_a(ResourceDumpManifest)

      md = urlset.metadata
      expect(md.capability).to eq('resourcedump-manifest')
      expect(md.at_time).to be_time(Time.utc(2013, 1, 3, 9))

      urls = urlset.resources
      expect(urls.size).to eq(2)
      url0 = urls[0]
      expect(url0.uri).to eq(URI('http://example.com/res1'))
      expect(url0.modified_time).to be_time(Time.utc(2013, 1, 3, 3))
      md0 = url0.metadata
      expect(md0.hashes).to eq('md5' => '1584abdf8ebdc9802ac0c6a7402c03b6')
      expect(md0.path).to eq('/resources/res1')

      url1 = urls[1]
      expect(url1.uri).to eq(URI('http://example.com/res2'))
      expect(url1.modified_time).to be_time(Time.utc(2013, 1, 3, 4))
      md1 = url1.metadata
      expect(md1.hashes).to eq('md5' => '1e0d5cb8ef6ba40c99b14c0237be735e')
      expect(md1.path).to eq('/resources/res2')
    end

    it 'parses example 6' do
      data = File.read('spec/data/examples/example-6.xml')
      urlset = XMLParser.parse(data)
      expect(urlset).to be_a(CapabilityList)

      links = urlset.links
      expect(links.size).to eq(2)
      ln0 = links[0]
      expect(ln0.rel).to eq('describedby')
      expect(ln0.uri).to eq(URI('http://example.com/info_about_set1_of_resources.xml'))
      ln1 = links[1]
      expect(ln1.rel).to eq('up')
      expect(ln1.uri).to eq(URI('http://example.com/resourcesync_description.xml'))

      md = urlset.metadata
      expect(md.capability).to eq('capabilitylist')

      urls = urlset.resources
      expect(urls.size).to eq(3)

      url0 = urls[0]
      expect(url0.uri).to eq(URI('http://example.com/dataset1/resourcelist.xml'))
      md0 = url0.metadata
      expect(md0.capability).to eq('resourcelist')

      url1 = urls[1]
      expect(url1.uri).to eq(URI('http://example.com/dataset1/resourcedump.xml'))
      md1 = url1.metadata
      expect(md1.capability).to eq('resourcedump')

      url2 = urls[2]
      expect(url2.uri).to eq(URI('http://example.com/dataset1/changelist.xml'))
      md2 = url2.metadata
      expect(md2.capability).to eq('changelist')
    end

    it 'parses example 7' do
      data = File.read('spec/data/examples/example-7.xml')
      urlset = XMLParser.parse(data)
      expect(urlset).to be_a(SourceDescription)

      links = urlset.links
      expect(links.size).to eq(1)
      ln = links[0]
      expect(ln.rel).to eq('describedby')
      expect(ln.uri).to eq(URI('http://example.com/info-about-source.xml'))

      md = urlset.metadata
      expect(md.capability).to eq('description')

      urls = urlset.resources
      expect(urls.size).to eq(1)

      url = urls[0]
      expect(url.uri).to eq(URI('http://example.com/dataset1/capabilitylist.xml'))
      md = url.metadata
      expect(md.capability).to eq('capabilitylist')
      links = url.links

      expect(links.size).to eq(1)
      ln = links[0]
      expect(ln.rel).to eq('describedby')
      expect(ln.uri).to eq(URI('http://example.com/info_about_set1_of_resources.xml'))
    end

    it 'parses example 8' do
      data = File.read('spec/data/examples/example-8.xml')
      sitemapindex = XMLParser.parse(data)
      expect(sitemapindex).to be_a(ResourceListIndex)

      md = sitemapindex.metadata
      expect(md.capability).to eq('resourcelist')
      expect(md.at_time).to be_time(Time.utc(2013, 1, 3, 9))

      sitemap = sitemapindex.resources
      expect(sitemap.size).to eq(2)

      sitemap0 = sitemap[0]
      expect(sitemap0.uri).to eq(URI('http://example.com/resourcelist-part1.xml'))

      sitemap1 = sitemap[1]
      expect(sitemap1.uri).to eq(URI('http://example.com/resourcelist-part2.xml'))
    end

    # Examples 9-11 aren't ResourceSync documents

    it 'parses example 12' do
      data = File.read('spec/data/examples/example-12.xml')
      urlset = XMLParser.parse(data)
      expect(urlset).to be_a(SourceDescription)

      links = urlset.links
      expect(links.size).to eq(1)
      ln = links[0]
      expect(ln.rel).to eq('describedby')
      expect(ln.uri).to eq(URI('http://example.com/info_about_source.xml'))

      md = urlset.metadata
      expect(md.capability).to eq('description')

      urls = urlset.resources
      expect(urls.size).to eq(3)

      (1..3).each do |i|
        url = urls[i - 1]
        expect(url.uri).to eq(URI("http://example.com/capabilitylist#{i}.xml"))
        md = url.metadata
        expect(md.capability).to eq('capabilitylist')
        links = url.links
        expect(links.size).to eq(1)
        ln = links[0]
        expect(ln.rel).to eq('describedby')
        expect(ln.uri).to eq(URI("http://example.com/info_about_set#{i}_of_resources.xml"))
      end
    end

    it 'parses example 13' do
      data = File.read('spec/data/examples/example-13.xml')
      urlset = XMLParser.parse(data)
      expect(urlset).to be_a(CapabilityList)

      links = urlset.links
      expect(links.size).to eq(2)
      ln0 = links[0]
      expect(ln0.rel).to eq('describedby')
      expect(ln0.uri).to eq(URI('http://example.com/info_about_set1_of_resources.xml'))
      ln1 = links[1]
      expect(ln1.rel).to eq('up')
      expect(ln1.uri).to eq(URI('http://example.com/resourcesync_description.xml'))

      md = urlset.metadata
      expect(md.capability).to eq('capabilitylist')

      urls = urlset.resources
      expect(urls.size).to eq(4)

      expected_capabilities = %w[resourcelist resourcedump changelist changedump]
      (0..3).each do |i|
        url = urls[i]
        capability = expected_capabilities[i]
        expect(url.uri).to eq(URI("http://example.com/dataset1/#{capability}.xml"))
        md = url.metadata
        expect(md.capability).to eq(capability)
      end
    end

    it 'parses example 14' do
      data = File.read('spec/data/examples/example-14.xml')
      urlset = XMLParser.parse(data)
      expect(urlset).to be_a(ResourceList)

      links = urlset.links
      expect(links.size).to eq(1)
      ln0 = links[0]
      expect(ln0.rel).to eq('up')
      expect(ln0.uri).to eq(URI('http://example.com/dataset1/capabilitylist.xml'))

      md = urlset.metadata
      expect(md.capability).to eq('resourcelist')
      expect(md.at_time).to be_time(Time.utc(2013, 1, 3, 9))
      expect(md.completed_time).to be_time(Time.utc(2013, 1, 3, 9, 1))

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
      end
    end

    it 'parses example 15' do
      data = File.read('spec/data/examples/example-15.xml')
      sitemapindex = XMLParser.parse(data)
      expect(sitemapindex).to be_a(ResourceListIndex)

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

    it 'parses example 16' do
      data = File.read('spec/data/examples/example-16.xml')
      urlset = XMLParser.parse(data)
      expect(urlset).to be_a(ResourceList)

      links = urlset.links
      expect(links.size).to eq(2)
      ln0 = links[0]
      expect(ln0.rel).to eq('up')
      expect(ln0.uri).to eq(URI('http://example.com/dataset1/capabilitylist.xml'))
      ln1 = links[1]
      expect(ln1.rel).to eq('index')
      expect(ln1.uri).to eq(URI('http://example.com/dataset1/resourcelist-index.xml'))

      md = urlset.metadata
      expect(md.capability).to eq('resourcelist')
      expect(md.at_time).to be_time(Time.utc(2013, 1, 3, 9))

      urls = urlset.resources
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

    it 'parses example 17' do
      data = File.read('spec/data/examples/example-17.xml')
      urlset = XMLParser.parse(data)
      expect(urlset).to be_a(ResourceDump)

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

    it 'parses example 18' do
      data = File.read('spec/data/examples/example-18.xml')
      urlset = XMLParser.parse(data)
      expect(urlset).to be_a(ResourceDumpManifest)

      links = urlset.links
      expect(links.size).to eq(1)
      ln0 = links[0]
      expect(ln0.rel).to eq('up')
      expect(ln0.uri).to eq(URI('http://example.com/dataset1/capabilitylist.xml'))

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

    it 'parses example 19' do
      data = File.read('spec/data/examples/example-19.xml')
      urlset = XMLParser.parse(data)
      expect(urlset).to be_a(ChangeList)

      links = urlset.links
      expect(links.size).to eq(1)
      ln0 = links[0]
      expect(ln0.rel).to eq('up')
      expect(ln0.uri).to eq(URI('http://example.com/dataset1/capabilitylist.xml'))

      md = urlset.metadata
      expect(md.capability).to eq('changelist')
      expect(md.from_time).to be_time(Time.utc(2013, 1, 3))

      urls = urlset.resources
      expect(urls.size).to eq(4)

      expected_filenames = %w[res1 res2 res3 res2]
      expected_extensions = %w[html pdf tiff pdf]
      expected_lastmods = [Time.utc(2013, 1, 3, 11), Time.utc(2013, 1, 3, 13), Time.utc(2013, 1, 3, 18), Time.utc(2013, 1, 3, 21)]

      expected_changes = [Types::Change::CREATED, Types::Change::UPDATED, Types::Change::DELETED, Types::Change::UPDATED]

      (0..3).each do |i|
        url = urls[i]
        expect(url.uri).to eq(URI("http://example.com/#{expected_filenames[i]}.#{expected_extensions[i]}"))
        expect(url.modified_time).to be_time(expected_lastmods[i])
        expect(url.metadata.change).to eq(expected_changes[i])
      end
    end

    it 'parses example 20' do
      data = File.read('spec/data/examples/example-20.xml')
      sitemapindex = XMLParser.parse(data)
      expect(sitemapindex).to be_a(ChangeListIndex)

      links = sitemapindex.links
      expect(links.size).to eq(1)
      ln0 = links[0]
      expect(ln0.rel).to eq('up')
      expect(ln0.uri).to eq(URI('http://example.com/dataset1/capabilitylist.xml'))

      md = sitemapindex.metadata
      expect(md.capability).to eq('changelist')
      expect(md.from_time).to be_time(Time.utc(2013, 1, 1))

      sitemaps = sitemapindex.resources
      expect(sitemaps.size).to eq(3)

      expected_froms = [Time.utc(2013, 1, 1), Time.utc(2013, 1, 2), Time.utc(2013, 1, 3)]
      expected_untils = [Time.utc(2013, 1, 2), Time.utc(2013, 1, 3), nil]
      (0..2).each do |i|
        sitemap = sitemaps[i]
        expect(sitemap.uri).to eq(URI("http://example.com/2013010#{i + 1}-changelist.xml"))
        md = sitemap.metadata
        expect(md.from_time).to be_time(expected_froms[i])
        expect(md.until_time).to be_time(expected_untils[i])
      end
    end

    it 'parses example 21' do
      data = File.read('spec/data/examples/example-21.xml')
      urlset = XMLParser.parse(data)
      expect(urlset).to be_a(ChangeList)

      links = urlset.links
      expect(links.size).to eq(2)
      ln0 = links[0]
      expect(ln0.rel).to eq('up')
      expect(ln0.uri).to eq(URI('http://example.com/dataset1/capabilitylist.xml'))
      ln1 = links[1]
      expect(ln1.rel).to eq('index')
      expect(ln1.uri).to eq(URI('http://example.com/dataset1/changelist.xml'))

      md = urlset.metadata
      expect(md.capability).to eq('changelist')
      expect(md.from_time).to be_time(Time.utc(2013, 1, 2))
      expect(md.until_time).to be_time(Time.utc(2013, 1, 3))

      urls = urlset.resources
      expect(urls.size).to eq(4)

      expected_filenames = %w[res7 res9 res5 res7]
      expected_extensions = %w[html pdf tiff html]
      expected_lastmods = [
        Time.utc(2013, 1, 2, 12),
        Time.utc(2013, 1, 2, 13),
        Time.utc(2013, 1, 2, 19),
        Time.utc(2013, 1, 2, 20)
      ]

      expected_changes = [Types::Change::CREATED, Types::Change::UPDATED, Types::Change::DELETED, Types::Change::UPDATED]

      (0..3).each do |i|
        url = urls[i]
        expect(url.uri).to eq(URI("http://example.com/#{expected_filenames[i]}.#{expected_extensions[i]}"))
        expect(url.modified_time).to be_time(expected_lastmods[i])
        expect(url.metadata.change).to eq(expected_changes[i])
      end
    end

    it 'parses example 22' do
      data = File.read('spec/data/examples/example-22.xml')
      urlset = XMLParser.parse(data)
      expect(urlset).to be_a(ChangeDump)

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

    it 'parses example 23' do
      data = File.read('spec/data/examples/example-23.xml')
      urlset = XMLParser.parse(data)
      expect(urlset).to be_a(ChangeDumpManifest)

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

      expected_filenames = %w[res7 res9 res5 res7]
      expected_extensions = %w[html pdf tiff html]
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

    it 'parses example 24' do
      data = File.read('spec/data/examples/example-24.xml')
      urlset = XMLParser.parse(data)
      expect(urlset).to be_a(ChangeList)

      links = urlset.links
      expect(links.size).to eq(1)
      ln0 = links[0]
      expect(ln0.rel).to eq('up')
      expect(ln0.uri).to eq(URI('http://example.com/dataset1/capabilitylist.xml'))

      md = urlset.metadata
      expect(md.capability).to eq('changelist')
      expect(md.from_time).to be_time(Time.utc(2013, 1, 3))

      urls = urlset.resources
      expect(urls.size).to eq(1)

      url = urls[0]
      expect(url.uri).to eq(URI('http://example.com/res1'))
      expect(url.modified_time).to be_time(Time.utc(2013, 1, 3, 18))
      md = url.metadata
      expect(md.change).to be(Types::Change::UPDATED)
      expect(md.hashes).to eq('md5' => '1584abdf8ebdc9802ac0c6a7402c03b6')
      expect(md.length).to eq(8876)
      expect(md.mime_type).to be_mime_type('text/html')

      links = url.links
      expect(links.size).to eq(3)
      expected_uris = [URI('http://mirror1.example.com/res1'),
                       URI('http://mirror2.example.com/res1'),
                       URI('gsiftp://gridftp.example.com/res1')]

      (0..2).each do |i|
        ln = links[i]
        expect(ln.rel).to eq('duplicate')
        expect(ln.priority).to eq(i + 1)
        expect(ln.uri).to eq(expected_uris[i])
        expect(ln.modified_time).to be_time(Time.utc(2013, 1, 3, 18))
      end
    end

    it 'parses example 25' do
      data = File.read('spec/data/examples/example-25.xml')
      urlset = XMLParser.parse(data)
      expect(urlset).to be_a(ChangeList)

      links = urlset.links
      expect(links.size).to eq(1)
      ln0 = links[0]
      expect(ln0.rel).to eq('up')
      expect(ln0.uri).to eq(URI('http://example.com/dataset1/capabilitylist.xml'))

      md = urlset.metadata
      expect(md.capability).to eq('changelist')
      expect(md.from_time).to be_time(Time.utc(2013, 1, 3, 11))

      urls = urlset.resources
      expect(urls.size).to eq(1)

      url = urls[0]
      expect(url.uri).to eq(URI('http://example.com/res1'))
      expect(url.modified_time).to be_time(Time.utc(2013, 1, 3, 18))
      md = url.metadata
      expect(md.change).to be(Types::Change::UPDATED)
      links = url.links
      expect(links.size).to eq(2)
      ln0 = links[0]
      expect(ln0.rel).to eq('alternate')
      expect(ln0.uri).to eq(URI('http://example.com/res1.html'))
      expect(ln0.modified_time).to be_time(Time.utc(2013, 1, 3, 18))
      expect(ln0.mime_type).to be_mime_type('text/html')
      ln1 = links[1]
      expect(ln1.rel).to eq('alternate')
      expect(ln1.uri).to eq(URI('http://example.com/res1.pdf'))
      expect(ln1.modified_time).to be_time(Time.utc(2013, 1, 3, 18))
      expect(ln1.mime_type).to be_mime_type('application/pdf')
    end

    it 'parses example 26' do
      data = File.read('spec/data/examples/example-26.xml')
      urlset = XMLParser.parse(data)
      expect(urlset).to be_a(ChangeList)

      links = urlset.links
      expect(links.size).to eq(1)
      ln = links[0]
      expect(ln.rel).to eq('up')
      expect(ln.uri).to eq(URI('http://example.com/dataset1/capabilitylist.xml'))

      md = urlset.metadata
      expect(md.capability).to eq('changelist')
      expect(md.from_time).to be_time(Time.utc(2013, 1, 3))

      urls = urlset.resources
      expect(urls.size).to eq(1)

      url = urls[0]
      expect(url.uri).to eq(URI('http://example.com/res1.html'))
      expect(url.modified_time).to be_time(Time.utc(2013, 1, 3, 18))
      md = url.metadata
      expect(md.change).to be(Types::Change::UPDATED)
      expect(md.hashes).to eq('md5' => '1584abdf8ebdc9802ac0c6a7402c03b6')
      expect(md.length).to eq(8876)
      links = url.links
      expect(links.size).to eq(1)
      ln = links[0]
      expect(ln.rel).to eq('canonical')
      expect(ln.uri).to eq(URI('http://example.com/res1'))
      expect(ln.modified_time).to be_time(Time.utc(2013, 1, 3, 18))
    end

    it 'parses example 27' do
      data = File.read('spec/data/examples/example-27.xml')
      urlset = XMLParser.parse(data)
      expect(urlset).to be_a(ChangeList)

      links = urlset.links
      expect(links.size).to eq(1)
      ln0 = links[0]
      expect(ln0.rel).to eq('up')
      expect(ln0.uri).to eq(URI('http://example.com/dataset1/capabilitylist.xml'))

      md = urlset.metadata
      expect(md.capability).to eq('changelist')
      expect(md.from_time).to be_time(Time.utc(2013, 1, 3))

      urls = urlset.resources
      expect(urls.size).to eq(2)

      url0 = urls[0]
      expect(url0.uri).to eq(URI('http://example.com/res4'))
      expect(url0.modified_time).to be_time(Time.utc(2013, 1, 3, 17))
      md0 = url0.metadata
      expect(md0.change).to be(Types::Change::UPDATED)
      expect(md0.hashes).to eq('sha-256' => 'f4OxZX_x_DFGFDgghgdfb6rtSx-iosjf6735432nklj')
      expect(md0.length).to eq(56_778)
      expect(md0.mime_type).to be_mime_type('application/json')
      lns0 = url0.links
      expect(lns0.size).to eq(1)
      ln0 = lns0[0]
      expect(ln0.rel).to(eq('http://www.openarchives.org/rs/terms/patch'))
      expect(ln0.uri).to(eq(URI('http://example.com/res4-json-patch')))
      expect(ln0.modified_time).to(eq(Time.utc(2013, 1, 3, 17)))
      expect(ln0.hashes).to(eq('sha-256' => 'y66dER_t_HWEIKpesdkeb7rtSc-ippjf9823742opld'))
      expect(ln0.length).to(eq(73))
      expect(ln0.mime_type).to(be_mime_type('application/json-patch'))

      url1 = urls[1]
      expect(url1.uri).to eq(URI('http://example.com/res5-full.tiff'))
      expect(url1.modified_time).to be_time(Time.utc(2013, 1, 3, 18))
      md1 = url1.metadata
      expect(md1.change).to be(Types::Change::UPDATED)
      expect(md1.hashes).to eq('sha-256' => 'f4OxZX_x_FO5LcGBSKHWXfwtSx-j1ncoSt3SABJtkGk')
      expect(md1.length).to eq(9_788_456_778)
      expect(md1.mime_type).to be_mime_type('image/tiff')
      lns1 = url1.links
      expect(lns1.size).to eq(1)
      ln1 = lns1[0]
      expect(ln1.rel).to(eq('http://www.openarchives.org/rs/terms/patch'))
      expect(ln1.uri).to(eq(URI('http://example.com/res5-diff')))
      expect(ln1.modified_time).to(eq(Time.utc(2013, 1, 3, 18)))
      expect(ln1.hashes).to(eq('sha-256' => 'h986gT_t_87HTkjHYE76G558hY-jdfgy76t55sadJUYT'))
      expect(ln1.length).to(eq(4533))
      expect(ln1.mime_type).to(be_mime_type('application/x-tiff-diff'))
    end

    it 'parses example 28' do
      data = File.read('spec/data/examples/example-28.xml')
      urlset = XMLParser.parse(data)
      expect(urlset).to be_a(ChangeList)

      links = urlset.links
      expect(links.size).to eq(1)
      ln0 = links[0]
      expect(ln0.rel).to eq('up')
      expect(ln0.uri).to eq(URI('http://example.com/dataset1/capabilitylist.xml'))

      md = urlset.metadata
      expect(md.capability).to eq('changelist')
      expect(md.from_time).to be_time(Time.utc(2013, 1, 3))

      urls = urlset.resources
      expect(urls.size).to eq(2)

      url0 = urls[0]
      expect(url0.uri).to eq(URI('http://example.com/res2.pdf'))
      expect(url0.modified_time).to be_time(Time.utc(2013, 1, 3, 18))
      md0 = url0.metadata
      expect(md0.change).to be(Types::Change::UPDATED)
      expect(md0.hashes).to eq('md5' => '1584abdf8ebdc9802ac0c6a7402c03b6')
      expect(md0.length).to eq(8876)
      expect(md0.mime_type).to be_mime_type('application/pdf')
      lns0 = url0.links
      expect(lns0.size).to eq(1)
      ln0 = lns0[0]
      expect(ln0.rel).to(eq('describedby'))
      expect(ln0.uri).to(eq(URI('http://example.com/res2_dublin-core_metadata.xml')))
      expect(ln0.modified_time).to(eq(Time.utc(2013, 1, 1, 12)))
      expect(ln0.mime_type).to(be_mime_type('application/xml'))

      url1 = urls[1]
      expect(url1.uri).to eq(URI('http://example.com/res2_dublin-core_metadata.xml'))
      expect(url1.modified_time).to be_time(Time.utc(2013, 1, 3, 19))
      md1 = url1.metadata
      expect(md1.change).to be(Types::Change::UPDATED)
      expect(md1.mime_type).to be_mime_type('application/xml')
      lns1 = url1.links
      expect(lns1.size).to eq(2)
      ln1 = lns1[0]
      expect(ln1.rel).to(eq('describes'))
      expect(ln1.uri).to(eq(URI('http://example.com/res2.pdf')))
      expect(ln1.modified_time).to(eq(Time.utc(2013, 1, 3, 18)))
      expect(ln1.hashes).to(eq('md5' => '1584abdf8ebdc9802ac0c6a7402c03b6'))
      expect(ln1.length).to(eq(8876))
      expect(ln1.mime_type).to(be_mime_type('application/pdf'))
      ln2 = lns1[1]
      expect(ln2.rel).to(eq('profile'))
      expect(ln2.uri).to(eq(URI('http://purl.org/dc/elements/1.1/')))
    end

    it 'parses example 29' do
      data = File.read('spec/data/examples/example-29.xml')
      urlset = XMLParser.parse(data)
      expect(urlset).to be_a(ChangeList)

      links = urlset.links
      expect(links.size).to eq(1)
      ln0 = links[0]
      expect(ln0.rel).to eq('up')
      expect(ln0.uri).to eq(URI('http://example.com/dataset1/capabilitylist.xml'))

      md = urlset.metadata
      expect(md.capability).to eq('changelist')
      expect(md.from_time).to be_time(Time.utc(2013, 1, 3))

      urls = urlset.resources
      expect(urls.size).to eq(1)

      url = urls[0]
      expect(url.uri).to eq(URI('http://example.com/res1'))
      expect(url.modified_time).to be_time(Time.utc(2013, 1, 3, 18))
      md = url.metadata
      expect(md.hashes).to eq('md5' => '1584abdf8ebdc9802ac0c6a7402c03b6')
      expect(md.length).to eq(8876)
      expect(md.mime_type).to be_mime_type('text/html')
      expect(md.change).to be(Types::Change::UPDATED)

      links = url.links
      expect(links.size).to eq(3)
      ln0 = links[0]
      expect(ln0.rel).to eq('memento')
      expect(ln0.uri).to eq(URI('http://example.com/20130103070000/res1'))
      expect(ln0.modified_time).to be_time(Time.utc(2013, 1, 2, 18))
      expect(ln0.mime_type).to be_mime_type('text/html')
      expect(md.hashes).to eq('md5' => '1584abdf8ebdc9802ac0c6a7402c03b6')
      expect(md.length).to eq(8876)
      expect(md.mime_type).to be_mime_type('text/html')
      ln1 = links[1]
      expect(ln1.rel).to eq('timegate')
      expect(ln1.uri).to eq(URI('http://example.com/timegate/http://example.com/res1'))
      ln2 = links[2]
      expect(ln2.rel).to eq('timemap')
      expect(ln2.uri).to eq(URI('http://example.com/timemap/http://example.com/res1'))
      expect(ln2.mime_type).to be_mime_type('application/link-format')
    end

    it 'parses example 30' do
      data = File.read('spec/data/examples/example-30.xml')
      urlset = XMLParser.parse(data)
      expect(urlset).to be_a(ChangeList)

      links = urlset.links
      expect(links.size).to eq(1)
      ln0 = links[0]
      expect(ln0.rel).to eq('up')
      expect(ln0.uri).to eq(URI('http://example.com/dataset1/capabilitylist.xml'))

      md = urlset.metadata
      expect(md.capability).to eq('changelist')
      expect(md.from_time).to be_time(Time.utc(2013, 1, 3))
      urls = urlset.resources
      expect(urls.size).to eq(1)

      url = urls[0]
      expect(url.uri).to eq(URI('http://example.com/res1'))
      expect(url.modified_time).to be_time(Time.utc(2013, 1, 3, 7))
      md = url.metadata
      expect(md.hashes).to eq('md5' => '1584abdf8ebdc9802ac0c6a7402c03b6')
      expect(md.length).to eq(8876)
      expect(md.mime_type).to be_mime_type('text/html')
      expect(md.change).to be(Types::Change::UPDATED)

      links = url.links
      ln = links[0]
      expect(ln.rel).to eq('collection')
      expect(ln.uri).to eq(URI('http://example.com/aggregation/0601007'))
    end

    it 'parses example 31' do
      data = File.read('spec/data/examples/example-31.xml')
      urlset = XMLParser.parse(data)
      expect(urlset).to be_a(ChangeList)

      links = urlset.links
      expect(links.size).to eq(1)
      ln0 = links[0]
      expect(ln0.rel).to eq('up')
      expect(ln0.uri).to eq(URI('http://example.com/dataset1/capabilitylist.xml'))

      md = urlset.metadata
      expect(md.capability).to eq('changelist')
      expect(md.from_time).to be_time(Time.utc(2013, 1, 3))
      urls = urlset.resources
      expect(urls.size).to eq(1)

      url = urls[0]
      expect(url.uri).to eq(URI('http://original.example.com/res1.html'))
      expect(url.modified_time).to be_time(Time.utc(2013, 1, 3, 7))
      md = url.metadata
      expect(md.hashes).to eq('md5' => '1584abdf8ebdc9802ac0c6a7402c03b6')
      expect(md.length).to eq(8876)
      expect(md.mime_type).to be_mime_type('text/html')
      expect(md.change).to be(Types::Change::UPDATED)
    end

    it 'parses example 32' do
      data = File.read('spec/data/examples/example-32.xml')
      urlset = XMLParser.parse(data)
      expect(urlset).to be_a(ChangeList)

      links = urlset.links
      expect(links.size).to eq(1)
      ln0 = links[0]
      expect(ln0.rel).to eq('up')
      expect(ln0.uri).to eq(URI('http://aggregator1.example.com/dataset1/capabilitylist.xml'))

      md = urlset.metadata
      expect(md.capability).to eq('changelist')
      expect(md.from_time).to be_time(Time.utc(2013, 1, 3, 11))
      urls = urlset.resources
      expect(urls.size).to eq(1)

      url = urls[0]
      expect(url.uri).to eq(URI('http://aggregator1.example.com/res1.html'))
      expect(url.modified_time).to be_time(Time.utc(2013, 1, 3, 20))
      md = url.metadata
      expect(md.hashes).to eq('md5' => '1584abdf8ebdc9802ac0c6a7402c03b6')
      expect(md.length).to eq(8876)
      expect(md.mime_type).to be_mime_type('text/html')
      expect(md.change).to be(Types::Change::UPDATED)

      links = url.links
      ln = links[0]
      expect(ln.rel).to eq('via')
      expect(ln.uri).to eq(URI('http://original.example.com/res1.html'))
      expect(ln.modified_time).to be_time(Time.utc(2013, 1, 3, 7))
      expect(ln.hashes).to eq('md5' => '1584abdf8ebdc9802ac0c6a7402c03b6')
      expect(ln.length).to eq(8876)
      expect(ln.mime_type).to be_mime_type('text/html')
    end

    it 'parses example 33' do
      data = File.read('spec/data/examples/example-33.xml')
      urlset = XMLParser.parse(data)
      expect(urlset).to be_a(ChangeList)

      links = urlset.links
      expect(links.size).to eq(1)
      ln0 = links[0]
      expect(ln0.rel).to eq('up')
      expect(ln0.uri).to eq(URI('http://aggregator2.example.com/dataset1/capabilitylist.xml'))

      md = urlset.metadata
      expect(md.capability).to eq('changelist')
      expect(md.from_time).to be_time(Time.utc(2013, 1, 3, 12))
      urls = urlset.resources
      expect(urls.size).to eq(1)

      url = urls[0]
      expect(url.uri).to eq(URI('http://aggregator2.example.com/res1.html'))
      expect(url.modified_time).to be_time(Time.utc(2013, 1, 4, 9))
      md = url.metadata
      expect(md.hashes).to eq('md5' => '1584abdf8ebdc9802ac0c6a7402c03b6')
      expect(md.length).to eq(8876)
      expect(md.mime_type).to be_mime_type('text/html')
      expect(md.change).to be(Types::Change::UPDATED)

      links = url.links
      ln = links[0]
      expect(ln.rel).to eq('via')
      expect(ln.uri).to eq(URI('http://original.example.com/res1.html'))
      expect(ln.modified_time).to be_time(Time.utc(2013, 1, 3, 7))
      expect(ln.hashes).to eq('md5' => '1584abdf8ebdc9802ac0c6a7402c03b6')
      expect(ln.length).to eq(8876)
      expect(ln.mime_type).to be_mime_type('text/html')
    end

    it 'parses a change dump index' do
      data = File.read('spec/data/changedump-index.xml')
      sitemapindex = XMLParser.parse(data)
      expect(sitemapindex).to be_a(ChangeDumpIndex)

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

    it 'parses a resource dump index' do
      data = File.read('spec/data/resourcedump-index.xml')
      sitemapindex = XMLParser.parse(data)
      expect(sitemapindex).to be_a(ResourceDumpIndex)

      links = sitemapindex.links
      expect(links.size).to eq(1)
      ln0 = links[0]
      expect(ln0.rel).to eq('up')
      expect(ln0.uri).to eq(URI('http://example.com/dataset1/capabilitylist.xml'))

      md = sitemapindex.metadata
      expect(md.capability).to eq('resourcedump')
      expect(md.at_time).to be_time(Time.utc(2013, 1, 3, 9))
      expect(md.completed_time).to be_time(Time.utc(2013, 1, 3, 9, 10))

      sitemaps = sitemapindex.resources
      expect(sitemaps.size).to eq(3)

      expected_times = [Time.utc(2013, 1, 3, 9), Time.utc(2013, 1, 3, 9, 3), Time.utc(2013, 1, 3, 9, 7)]
      (0..2).each do |i|
        sitemap = sitemaps[i]
        expect(sitemap.uri).to eq(URI("http://example.com/resourcedump#{i + 1}.xml"))
        md = sitemap.metadata
        expect(md.at_time).to be_time(expected_times[i])
      end
    end
  end
end
