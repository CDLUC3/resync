require 'spec_helper'

module Resync
  describe Parser do

    it 'parses example 1' do
      data = File.read('spec/data/examples/example-1.xml')
      urlset = Parser.parse(data)

      md = urlset.md
      expect(md).not_to be_nil
      expect(md.capability).to eq('resourcelist')
      expect(md.at).to eq(DateTime.new(2013, 1, 3, 9))

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
      expect(md.at).to eq(DateTime.new(2013, 1, 3, 9))

      urls = urlset.url
      expect(urls.size).to eq(2)

      url0 = urls[0]
      expect(url0.loc).to eq(URI('http://example.com/res1'))
      expect(url0.lastmod).to eq(DateTime.new(2013, 1, 2, 13))
      md0 = url0.md
      expect(md0).not_to be_nil
      expect(md0.hash).to eq('md5:1584abdf8ebdc9802ac0c6a7402c03b6')
      lns0 = urls[0].ln
      expect(lns0.size).to eq(0)

      url1 = urls[1]
      expect(url1.loc).to eq(URI('http://example.com/res2'))
      expect(url1.lastmod).to eq(DateTime.new(2013, 1, 2, 14))
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
      expect(url0.lastmod).to eq(DateTime.new(2013, 1, 2, 13))
      md0 = url0.md
      expect(md0).not_to be_nil
      expect(md0.change).to be(Change::UPDATED)

      url1 = urls[1]
      expect(url1.loc).to eq(URI('http://example.com/res3.tiff'))
      expect(url1.lastmod).to eq(DateTime.new(2013, 1, 2, 18))
      md1 = url1.md
      expect(md1).not_to be_nil
      expect(md1.change).to be(Change::DELETED)
    end

    it 'parses example 4' do
      data = File.read('spec/data/examples/example-4.xml')
      urlset = Parser.parse(data)

      md = urlset.md
      expect(md.capability).to eq('resourcedump')
      expect(md.at).to eq(DateTime.new(2013, 1, 3, 9))

      urls = urlset.url
      expect(urls.size).to eq(1)

      url0 = urls[0]
      expect(url0.loc).to eq(URI('http://example.com/resourcedump.zip'))
      expect(url0.lastmod).to eq(DateTime.new(2013,1,3,9))
    end

    it 'parses example 5' do
      data = File.read('spec/data/examples/example-5.xml')
      urlset = Parser.parse(data)

      md = urlset.md
      expect(md.capability).to eq('resourcedump-manifest')
      expect(md.at).to eq(DateTime.new(2013, 1, 3, 9))

      urls = urlset.url
      expect(urls.size).to eq(2)
      url0 = urls[0]
      expect(url0.loc).to eq(URI('http://example.com/res1'))
      expect(url0.lastmod).to eq(DateTime.new(2013, 1, 3, 3))
      md0 = url0.md
      expect(md0.hash).to eq('md5:1584abdf8ebdc9802ac0c6a7402c03b6')
      expect(md0.path).to eq('/resources/res1')

      url1 = urls[1]
      expect(url1.loc).to eq(URI('http://example.com/res2'))
      expect(url1.lastmod).to eq(DateTime.new(2013, 1, 3, 4))
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
      md = rs.md
      expect(md.capability).to eq('capabilitylist')
      ln = rs.ln
      expect(ln.rel).to eq('describedby')
      expect(ln.href).to eq(URI('http://example.com/info_about_set1_of_resources.xml'))
    end
  end
end
