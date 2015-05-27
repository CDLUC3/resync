require 'spec_helper'

module Resync
  describe XMLParser do

    describe '#parse' do
      it 'parses an XML document' do
        data = File.read('spec/data/examples/example-1.xml')
        doc = REXML::Document.new(data)
        urlset = XMLParser.parse(doc)
        expect(urlset).to be_a(ResourceList)
      end

      it 'parses a urlset' do
        data = File.read('spec/data/examples/example-1.xml')
        root = REXML::Document.new(data).root
        urlset = XMLParser.parse(root)
        expect(urlset).to be_a(ResourceList)
      end

      it 'parses a sitemapindex' do
        data = File.read('spec/data/examples/example-8.xml')
        root = REXML::Document.new(data).root
        sitemapindex = XMLParser.parse(root)
        expect(sitemapindex).to be_a(ResourceListIndex)
      end

      it 'parses a String' do
        data = File.read('spec/data/examples/example-1.xml')
        urlset = XMLParser.parse(data)
        expect(urlset).to be_a(ResourceList)
      end

      it 'parses an XML fragment' do
        data = '<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9" xmlns:rs="http://www.openarchives.org/rs/terms/">
                  <rs:md capability="resourcelist" at="2013-01-03T09:00:00Z"/>
                  <url><loc>http://example.com/res1</loc></url>
                </urlset>'
        urlset = XMLParser.parse(data)
        expect(urlset).to be_a(ResourceList)
      end

      it 'fails if the root element has no metadata' do
        data = '<?xml version="1.0" encoding="UTF-8"?>
                <urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9" xmlns:rs="http://www.openarchives.org/rs/terms/">
                  <url><loc>http://example.com/res1</loc></url>
                </urlset>'
        expect { XMLParser.parse(data) }.to raise_error(ArgumentError)
      end

      it 'fails if the root element\'s metadata has no capability attribute' do
        data = '<?xml version="1.0" encoding="UTF-8"?>
                <urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9" xmlns:rs="http://www.openarchives.org/rs/terms/">
                  <rs:md at="2013-01-03T09:00:00Z"/>
                  <url><loc>http://example.com/res1</loc></url>
                </urlset>'
        expect { XMLParser.parse(data) }.to raise_error(ArgumentError)
      end

      it 'fails if the root element\'s metadata has an unknown capability attribute' do
        data = '<?xml version="1.0" encoding="UTF-8"?>
                <urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9" xmlns:rs="http://www.openarchives.org/rs/terms/">
                  <rs:md capability="NOT A CAPABILITY" at="2013-01-03T09:00:00Z"/>
                  <url><loc>http://example.com/res1</loc></url>
                </urlset>'
        expect { XMLParser.parse(data) }.to raise_error(ArgumentError)
      end

      it 'fails when it gets something other than a <urlset/> or <sitemapindex/>' do
        data = '<loc>http://example.com/resourcelist-part1.xml</loc>'
        expect { XMLParser.parse(data) }.to raise_error(ArgumentError)
      end

      it 'fails when it gets something other than XML' do
        data = 12_345
        expect { XMLParser.parse(data) }.to raise_error(ArgumentError)
      end

    end

  end
end
