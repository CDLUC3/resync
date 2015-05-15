require 'rspec_custom_matchers'
require 'resync'
#require 'spec_helper'

module Resync
  describe XMLFactory do

    describe '#parse' do
      it 'parses an XML document' do
        data = File.read('spec/data/examples/example-1.xml')
        doc = REXML::Document.new(data)
        urlset = XMLFactory.parse(xml: doc)
        expect(urlset).to be_a(ResourceList)
      end

      it 'parses a urlset' do
        data = File.read('spec/data/examples/example-1.xml')
        root = REXML::Document.new(data).root
        urlset = XMLFactory.parse(xml: root)
        expect(urlset).to be_a(ResourceList)
      end

      it 'parses a sitemapindex' do
        data = File.read('spec/data/examples/example-8.xml')
        root = REXML::Document.new(data).root
        sitemapindex = XMLFactory.parse(xml: root)
        expect(sitemapindex).to be_a(ResourceList)
      end

      it 'parses a String' do
        data = File.read('spec/data/examples/example-1.xml')
        urlset = XMLFactory.parse(xml: data)
        expect(urlset).to be_a(ResourceList)
      end

      it 'fails when it gets something other than a <urlset/> or <sitemapindex/>' do
        data = '<loc>http://example.com/resourcelist-part1.xml</loc>'
        expect { XMLFactory.parse(xml: data) }.to raise_exception
      end

      it 'fails when it gets something other than XML' do
        data = 12_345
        expect { XMLFactory.parse(xml: data) }.to raise_exception
      end

    end

  end
end
