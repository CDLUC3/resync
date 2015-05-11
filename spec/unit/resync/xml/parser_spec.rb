require 'spec_helper'

module Resync
  module XML
    describe Parser do

      describe '#parse' do
        it 'parses an XML document' do
          data = File.read('spec/data/examples/example-1.xml')
          doc = REXML::Document.new(data)
          urlset = Parser.parse(doc)
          expect(urlset).to be_a(Urlset)
        end

        it 'parses a urlset' do
          data = File.read('spec/data/examples/example-1.xml')
          root = REXML::Document.new(data).root
          urlset = Parser.parse(root)
          expect(urlset).to be_a(Urlset)
        end

        it 'parses a sitemapindex' do
          data = File.read('spec/data/examples/example-8.xml')
          root = REXML::Document.new(data).root
          sitemapindex = Parser.parse(root)
          expect(sitemapindex).to be_a(Sitemapindex)
        end

        it 'parses a String' do
          data = File.read('spec/data/examples/example-1.xml')
          urlset = Parser.parse(data)
          expect(urlset).to be_a(Urlset)
        end

        it 'fails when it gets something other than a <urlset/> or <sitemapindex/>' do
          data = '<loc>http://example.com/resourcelist-part1.xml</loc>'
          expect { Parser.parse(data) }.to raise_exception
        end

        it 'fails when it gets something other than XML' do
          data = 12_345
          expect { Parser.parse(data) }.to raise_exception
        end

      end

    end
  end
end
