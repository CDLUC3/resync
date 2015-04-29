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
  end
end
