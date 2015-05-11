require 'spec_helper'

module Resync
  module XML

    Change = Resync::Types::Change

    describe Parser do

      it 'parses example 1' do
        data = File.read('spec/data/examples/example-1.xml')
        urlset = Parser.parse(data)

        md = urlset.md
        expect(md).not_to be_nil
        expect(md.capability).to eq('resourcelist')
        expect(md.at).to be_time(Time.utc(2013, 1, 3, 9))

        urls = urlset.url
        expect(urls.size).to eq(2)

        url0 = urls[0]
        expect(url0.loc).to eq(URI('http://example.com/res1'))

        url1 = urls[1]
        expect(url1.loc).to eq(URI('http://example.com/res2'))
      end

      it 'parses example 2' do
        data = File.read('spec/data/examples/example-2.xml')
        urlset = Parser.parse(data)

        md = urlset.md
        expect(md).not_to be_nil
        expect(md.capability).to eq('resourcelist')
        expect(md.at).to be_time(Time.utc(2013, 1, 3, 9))

        urls = urlset.url
        expect(urls.size).to eq(2)

        url0 = urls[0]
        expect(url0.loc).to eq(URI('http://example.com/res1'))
        expect(url0.lastmod).to be_time(Time.utc(2013, 1, 2, 13))
        md0 = url0.md
        expect(md0).not_to be_nil
        expect(md0.hash).to eq('md5:1584abdf8ebdc9802ac0c6a7402c03b6')
        lns0 = urls[0].ln
        expect(lns0.size).to eq(0)

        url1 = urls[1]
        expect(url1.loc).to eq(URI('http://example.com/res2'))
        expect(url1.lastmod).to be_time(Time.utc(2013, 1, 2, 14))
        md1 = url1.md
        expect(md1).not_to be_nil
        expect(md1.hash).to eq('md5:1e0d5cb8ef6ba40c99b14c0237be735e')
        lns1 = urls[1].ln
        expect(lns1.size).to eq(1)
        ln1 = lns1[0]
        expect(ln1.rel).to eq('duplicate')
        expect(ln1.href).to eq(URI('http://mirror.example.com/res2'))
      end

      it 'parses example 3' do
        data = File.read('spec/data/examples/example-3.xml')
        urlset = Parser.parse(data)

        urls = urlset.url
        expect(urls.size).to eq(2)
        url0 = urls[0]
        expect(url0.loc).to eq(URI('http://example.com/res2.pdf'))
        expect(url0.lastmod).to be_time(Time.utc(2013, 1, 2, 13))
        md0 = url0.md
        expect(md0).not_to be_nil
        expect(md0.change).to be(Resync::Types::Change::UPDATED)

        url1 = urls[1]
        expect(url1.loc).to eq(URI('http://example.com/res3.tiff'))
        expect(url1.lastmod).to be_time(Time.utc(2013, 1, 2, 18))
        md1 = url1.md
        expect(md1).not_to be_nil
        expect(md1.change).to be(Resync::Types::Change::DELETED)
      end

      it 'parses example 4' do
        data = File.read('spec/data/examples/example-4.xml')
        urlset = Parser.parse(data)

        md = urlset.md
        expect(md.capability).to eq('resourcedump')
        expect(md.at).to be_time(Time.utc(2013, 1, 3, 9))

        urls = urlset.url
        expect(urls.size).to eq(1)

        url0 = urls[0]
        expect(url0.loc).to eq(URI('http://example.com/resourcedump.zip'))
        expect(url0.lastmod).to be_time(Time.utc(2013, 1, 3, 9))
      end

      it 'parses example 5' do
        data = File.read('spec/data/examples/example-5.xml')
        urlset = Parser.parse(data)

        md = urlset.md
        expect(md.capability).to eq('resourcedump-manifest')
        expect(md.at).to be_time(Time.utc(2013, 1, 3, 9))

        urls = urlset.url
        expect(urls.size).to eq(2)
        url0 = urls[0]
        expect(url0.loc).to eq(URI('http://example.com/res1'))
        expect(url0.lastmod).to be_time(Time.utc(2013, 1, 3, 3))
        md0 = url0.md
        expect(md0.hash).to eq('md5:1584abdf8ebdc9802ac0c6a7402c03b6')
        expect(md0.path).to eq('/resources/res1')

        url1 = urls[1]
        expect(url1.loc).to eq(URI('http://example.com/res2'))
        expect(url1.lastmod).to be_time(Time.utc(2013, 1, 3, 4))
        md1 = url1.md
        expect(md1.hash).to eq('md5:1e0d5cb8ef6ba40c99b14c0237be735e')
        expect(md1.path).to eq('/resources/res2')
      end

      it 'parses example 6' do
        data = File.read('spec/data/examples/example-6.xml')
        urlset = Parser.parse(data)

        lns = urlset.ln
        expect(lns.size).to eq(2)
        ln0 = lns[0]
        expect(ln0.rel).to eq('describedby')
        expect(ln0.href).to eq(URI('http://example.com/info_about_set1_of_resources.xml'))
        ln1 = lns[1]
        expect(ln1.rel).to eq('up')
        expect(ln1.href).to eq(URI('http://example.com/resourcesync_description.xml'))

        md = urlset.md
        expect(md.capability).to eq('capabilitylist')

        urls = urlset.url
        expect(urls.size).to eq(3)

        url0 = urls[0]
        expect(url0.loc).to eq(URI('http://example.com/dataset1/resourcelist.xml'))
        md0 = url0.md
        expect(md0.capability).to eq('resourcelist')

        url1 = urls[1]
        expect(url1.loc).to eq(URI('http://example.com/dataset1/resourcedump.xml'))
        md1 = url1.md
        expect(md1.capability).to eq('resourcedump')

        url2 = urls[2]
        expect(url2.loc).to eq(URI('http://example.com/dataset1/changelist.xml'))
        md2 = url2.md
        expect(md2.capability).to eq('changelist')
      end

      it 'parses example 7' do
        data = File.read('spec/data/examples/example-7.xml')
        urlset = Parser.parse(data)

        lns = urlset.ln
        expect(lns.size).to eq(1)
        ln = lns[0]
        expect(ln.rel).to eq('describedby')
        expect(ln.href).to eq(URI('http://example.com/info-about-source.xml'))

        md = urlset.md
        expect(md.capability).to eq('description')

        urls = urlset.url
        expect(urls.size).to eq(1)

        url = urls[0]
        expect(url.loc).to eq(URI('http://example.com/dataset1/capabilitylist.xml'))
        md = url.md
        expect(md.capability).to eq('capabilitylist')
        lns = url.ln

        expect(lns.size).to eq(1)
        ln = lns[0]
        expect(ln.rel).to eq('describedby')
        expect(ln.href).to eq(URI('http://example.com/info_about_set1_of_resources.xml'))
      end

      it 'parses example 8' do
        data = File.read('spec/data/examples/example-8.xml')
        sitemapindex = Parser.parse(data)

        md = sitemapindex.md
        expect(md.capability).to eq('resourcelist')
        expect(md.at).to be_time(Time.utc(2013, 1, 3, 9))

        sitemap = sitemapindex.sitemap
        expect(sitemap.size).to eq(2)

        sitemap0 = sitemap[0]
        expect(sitemap0.loc).to eq(URI('http://example.com/resourcelist-part1.xml'))

        sitemap1 = sitemap[1]
        expect(sitemap1.loc).to eq(URI('http://example.com/resourcelist-part2.xml'))
      end

      # Examples 9-11 aren't ResourceSync documents

      it 'parses example 12' do
        data = File.read('spec/data/examples/example-12.xml')
        urlset = Parser.parse(data)

        lns = urlset.ln
        expect(lns.size).to eq(1)
        ln = lns[0]
        expect(ln.rel).to eq('describedby')
        expect(ln.href).to eq(URI('http://example.com/info_about_source.xml'))

        md = urlset.md
        expect(md.capability).to eq('description')

        urls = urlset.url
        expect(urls.size).to eq(3)

        (1..3).each do |i|
          url = urls[i - 1]
          expect(url.loc).to eq(URI("http://example.com/capabilitylist#{i}.xml"))
          md = url.md
          expect(md.capability).to eq('capabilitylist')
          lns = url.ln
          expect(lns.size).to eq(1)
          ln = lns[0]
          expect(ln.rel).to eq('describedby')
          expect(ln.href).to eq(URI("http://example.com/info_about_set#{i}_of_resources.xml"))
        end
      end

      it 'parses example 13' do
        data = File.read('spec/data/examples/example-13.xml')
        urlset = Parser.parse(data)

        lns = urlset.ln
        expect(lns.size).to eq(2)
        ln0 = lns[0]
        expect(ln0.rel).to eq('describedby')
        expect(ln0.href).to eq(URI('http://example.com/info_about_set1_of_resources.xml'))
        ln1 = lns[1]
        expect(ln1.rel).to eq('up')
        expect(ln1.href).to eq(URI('http://example.com/resourcesync_description.xml'))

        md = urlset.md
        expect(md.capability).to eq('capabilitylist')

        urls = urlset.url
        expect(urls.size).to eq(4)

        expected_capabilities = %w(resourcelist resourcedump changelist changedump)
        (0..3).each do |i|
          url = urls[i]
          capability = expected_capabilities[i]
          expect(url.loc).to eq(URI("http://example.com/dataset1/#{capability}.xml"))
          md = url.md
          expect(md.capability).to eq(capability)
        end
      end

      it 'parses example 14' do
        data = File.read('spec/data/examples/example-14.xml')
        urlset = Parser.parse(data)

        lns = urlset.ln
        expect(lns.size).to eq(1)
        ln0 = lns[0]
        expect(ln0.rel).to eq('up')
        expect(ln0.href).to eq(URI('http://example.com/dataset1/capabilitylist.xml'))

        md = urlset.md
        expect(md.capability).to eq('resourcelist')
        expect(md.at).to be_time(Time.utc(2013, 1, 3, 9))
        expect(md.completed).to be_time(Time.utc(2013, 1, 3, 9, 1))

        urls = urlset.url
        expect(urls.size).to eq(2)

        expected_lastmods = [Time.utc(2013, 1, 2, 13), Time.utc(2013, 1, 2, 14)]
        expected_hashes = ['md5:1584abdf8ebdc9802ac0c6a7402c03b6', 'md5:1e0d5cb8ef6ba40c99b14c0237be735e sha-256:854f61290e2e197a11bc91063afce22e43f8ccc655237050ace766adc68dc784']
        expected_lengths = [8876, 14_599]
        expected_types = [MIME::Types['text/html'].first, MIME::Types['application/pdf'].first]

        (0..1).each do |i|
          url = urls[i]
          expect(url.loc).to eq(URI("http://example.com/res#{i + 1}"))
          expect(url.lastmod).to be_time(expected_lastmods[i])
          md = url.md
          expect(md.hash).to eq(expected_hashes[i])
          expect(md.length).to eq(expected_lengths[i])
          expect(md.type).to eq(expected_types[i])
        end
      end

      it 'parses example 15' do
        data = File.read('spec/data/examples/example-15.xml')
        sitemapindex = Parser.parse(data)

        lns = sitemapindex.ln
        expect(lns.size).to eq(1)
        ln0 = lns[0]
        expect(ln0.rel).to eq('up')
        expect(ln0.href).to eq(URI('http://example.com/dataset1/capabilitylist.xml'))

        md = sitemapindex.md
        expect(md.capability).to eq('resourcelist')
        expect(md.at).to be_time(Time.utc(2013, 1, 3, 9))
        expect(md.completed).to be_time(Time.utc(2013, 1, 3, 9, 10))

        sitemaps = sitemapindex.sitemap
        expect(sitemaps.size).to eq(3)

        expected_times = [Time.utc(2013, 1, 3, 9), Time.utc(2013, 1, 3, 9, 3), Time.utc(2013, 1, 3, 9, 7)]
        (0..2).each do |i|
          sitemap = sitemaps[i]
          expect(sitemap.loc).to eq(URI("http://example.com/resourcelist#{i + 1}.xml"))
          md = sitemap.md
          expect(md.at).to be_time(expected_times[i])
        end
      end

      it 'parses example 16' do
        data = File.read('spec/data/examples/example-16.xml')
        urlset = Parser.parse(data)

        lns = urlset.ln
        expect(lns.size).to eq(2)
        ln0 = lns[0]
        expect(ln0.rel).to eq('up')
        expect(ln0.href).to eq(URI('http://example.com/dataset1/capabilitylist.xml'))
        ln1 = lns[1]
        expect(ln1.rel).to eq('index')
        expect(ln1.href).to eq(URI('http://example.com/dataset1/resourcelist-index.xml'))

        md = urlset.md
        expect(md.capability).to eq('resourcelist')
        expect(md.at).to be_time(Time.utc(2013, 1, 3, 9))

        urls = urlset.url
        expect(urls.size).to eq(2)

        expected_lastmods = [Time.utc(2013, 1, 2, 13), Time.utc(2013, 1, 2, 14)]
        expected_hashes = ['md5:1584abdf8ebdc9802ac0c6a7402c8753', 'md5:4556abdf8ebdc9802ac0c6a7402c9881']
        expected_lengths = [4385, 883]
        expected_types = [MIME::Types['application/pdf'].first, MIME::Types['image/png'].first]

        (0..1).each do |i|
          url = urls[i]
          expect(url.loc).to eq(URI("http://example.com/res#{i + 3}"))
          expect(url.lastmod).to be_time(expected_lastmods[i])
          md = url.md
          expect(md.hash).to eq(expected_hashes[i])
          expect(md.length).to eq(expected_lengths[i])
          expect(md.type).to eq(expected_types[i])
        end
      end

      it 'parses example 17' do
        data = File.read('spec/data/examples/example-17.xml')
        urlset = Parser.parse(data)

        lns = urlset.ln
        expect(lns.size).to eq(1)
        ln0 = lns[0]
        expect(ln0.rel).to eq('up')
        expect(ln0.href).to eq(URI('http://example.com/dataset1/capabilitylist.xml'))

        md = urlset.md
        expect(md.capability).to eq('resourcedump')
        expect(md.at).to be_time(Time.utc(2013, 1, 3, 9))
        expect(md.completed).to be_time(Time.utc(2013, 1, 3, 9, 4))

        urls = urlset.url
        expect(urls.size).to eq(3)

        expected_lengths = [4765, 9875, 2298]
        expected_ats = [Time.utc(2013, 1, 3, 9), Time.utc(2013, 1, 3, 9, 1), Time.utc(2013, 1, 3, 9, 3)]
        expected_completeds = [Time.utc(2013, 1, 3, 9, 2), Time.utc(2013, 1, 3, 9, 3), Time.utc(2013, 1, 3, 9, 4)]

        (0..2).each do |i|
          url = urls[i]
          expect(url.loc).to eq(URI("http://example.com/resourcedump-part#{i + 1}.zip"))
          md = url.md
          expect(md.type).to eq(MIME::Types['application/zip'].first)
          expect(md.length).to eq(expected_lengths[i])
          expect(md.at).to be_time(expected_ats[i])
          expect(md.completed).to be_time(expected_completeds[i])
          lns = url.ln
          expect(lns.size).to eq(1)
          ln = lns[0]
          expect(ln.rel).to eq('contents')
          expect(ln.href).to eq(URI("http://example.com/resourcedump_manifest-part#{i + 1}.xml"))
          expect(ln.type).to eq(MIME::Types['application/xml'].first)
        end
      end

      it 'parses example 18' do
        data = File.read('spec/data/examples/example-18.xml')
        urlset = Parser.parse(data)

        lns = urlset.ln
        expect(lns.size).to eq(1)
        ln0 = lns[0]
        expect(ln0.rel).to eq('up')
        expect(ln0.href).to eq(URI('http://example.com/dataset1/capabilitylist.xml'))

        md = urlset.md
        expect(md.capability).to eq('resourcedump-manifest')
        expect(md.at).to be_time(Time.utc(2013, 1, 3, 9))
        expect(md.completed).to be_time(Time.utc(2013, 1, 3, 9, 2))

        urls = urlset.url
        expect(urls.size).to eq(2)

        expected_lastmods = [Time.utc(2013, 1, 2, 13), Time.utc(2013, 1, 2, 14)]
        expected_hashes = ['md5:1584abdf8ebdc9802ac0c6a7402c03b6', 'md5:1e0d5cb8ef6ba40c99b14c0237be735e sha-256:854f61290e2e197a11bc91063afce22e43f8ccc655237050ace766adc68dc784']
        expected_lengths = [8876, 14_599]
        expected_types = [MIME::Types['text/html'].first, MIME::Types['application/pdf'].first]

        (0..1).each do |i|
          url = urls[i]
          expect(url.loc).to eq(URI("http://example.com/res#{i + 1}"))
          expect(url.lastmod).to be_time(expected_lastmods[i])
          md = url.md
          expect(md.hash).to eq(expected_hashes[i])
          expect(md.length).to eq(expected_lengths[i])
          expect(md.type).to eq(expected_types[i])
          expect(md.path).to eq("/resources/res#{i + 1}")
        end
      end

      it 'parses example 19' do
        data = File.read('spec/data/examples/example-19.xml')
        urlset = Parser.parse(data)

        lns = urlset.ln
        expect(lns.size).to eq(1)
        ln0 = lns[0]
        expect(ln0.rel).to eq('up')
        expect(ln0.href).to eq(URI('http://example.com/dataset1/capabilitylist.xml'))

        md = urlset.md
        expect(md.capability).to eq('changelist')
        expect(md.from).to be_time(Time.utc(2013, 1, 3))

        urls = urlset.url
        expect(urls.size).to eq(4)

        expected_filenames = %w(res1 res2 res3 res2)
        expected_extensions = %w(html pdf tiff pdf)
        expected_lastmods = [Time.utc(2013, 1, 3, 11), Time.utc(2013, 1, 3, 13), Time.utc(2013, 1, 3, 18), Time.utc(2013, 1, 3, 21)]

        expected_changes = [Change::CREATED, Change::UPDATED, Change::DELETED, Change::UPDATED]

        (0..3).each do |i|
          url = urls[i]
          expect(url.loc).to eq(URI("http://example.com/#{expected_filenames[i]}.#{expected_extensions[i]}"))
          expect(url.lastmod).to be_time(expected_lastmods[i])
          expect(url.md.change).to eq(expected_changes[i])
        end
      end

      it 'parses example 20' do
        data = File.read('spec/data/examples/example-20.xml')
        sitemapindex = Parser.parse(data)

        lns = sitemapindex.ln
        expect(lns.size).to eq(1)
        ln0 = lns[0]
        expect(ln0.rel).to eq('up')
        expect(ln0.href).to eq(URI('http://example.com/dataset1/capabilitylist.xml'))

        md = sitemapindex.md
        expect(md.capability).to eq('changelist')
        expect(md.from).to be_time(Time.utc(2013, 1, 1))

        sitemaps = sitemapindex.sitemap
        expect(sitemaps.size).to eq(3)

        expected_froms = [Time.utc(2013, 1, 1), Time.utc(2013, 1, 2), Time.utc(2013, 1, 3)]
        expected_untils = [Time.utc(2013, 1, 2), Time.utc(2013, 1, 3), nil]
        (0..2).each do |i|
          sitemap = sitemaps[i]
          expect(sitemap.loc).to eq(URI("http://example.com/2013010#{i + 1}-changelist.xml"))
          md = sitemap.md
          expect(md.from).to be_time(expected_froms[i])
          expect(md.until).to be_time(expected_untils[i])
        end
      end

      it 'parses example 21' do
        data = File.read('spec/data/examples/example-21.xml')
        urlset = Parser.parse(data)

        lns = urlset.ln
        expect(lns.size).to eq(2)
        ln0 = lns[0]
        expect(ln0.rel).to eq('up')
        expect(ln0.href).to eq(URI('http://example.com/dataset1/capabilitylist.xml'))
        ln1 = lns[1]
        expect(ln1.rel).to eq('index')
        expect(ln1.href).to eq(URI('http://example.com/dataset1/changelist.xml'))

        md = urlset.md
        expect(md.capability).to eq('changelist')
        expect(md.from).to be_time(Time.utc(2013, 1, 2))
        expect(md.until).to be_time(Time.utc(2013, 1, 3))

        urls = urlset.url
        expect(urls.size).to eq(4)

        expected_filenames = %w(res7 res9 res5 res7)
        expected_extensions = %w(html pdf tiff html)
        expected_lastmods = [Time.utc(2013, 1, 2, 12), Time.utc(2013, 1, 2, 13), Time.utc(2013, 1, 2, 19), Time.utc(2013, 1, 2, 20)]

        expected_changes = [Change::CREATED, Change::UPDATED, Change::DELETED, Change::UPDATED]

        (0..3).each do |i|
          url = urls[i]
          expect(url.loc).to eq(URI("http://example.com/#{expected_filenames[i]}.#{expected_extensions[i]}"))
          expect(url.lastmod).to be_time(expected_lastmods[i])
          expect(url.md.change).to eq(expected_changes[i])
        end
      end

    end

  end
end
