require 'spec_helper'

module Resync
  describe XMLParser do

    it 'can still load sitemaps after saving metadata with :sitemapindex mapping' do
      md = Metadata.new(capability: 'resourcelist' )
      md.save_to_xml({ mapping: :sitemapindex })

      data = File.read('spec/data/examples/example-8.xml')
      root = REXML::Document.new(data).root
      sitemapindex = XMLParser.parse(xml: root)
      expect(sitemapindex).to be_a(ResourceList)
    end

    it 'can still load sitemaps after saving resource with :sitemapindex mapping' do
      resource = Resource.new(
          uri: 'http://example.com/res1',
          links: [Link.new(rel:'duplicate', href:'http://mirror.example.com/res1')]
      )
      resource.save_to_xml({ mapping: :sitemapindex })

      data = File.read('spec/data/examples/example-8.xml')
      root = REXML::Document.new(data).root
      sitemapindex = XMLParser.parse(xml: root)
      expect(sitemapindex).to be_a(ResourceList)
    end

  end
end
