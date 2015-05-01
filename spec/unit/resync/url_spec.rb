require 'spec_helper'

module Resync
  describe Url do
    def parse(xml_string)
      doc = REXML::Document.new(xml_string)
      Url.load_from_xml(doc.root)
    end

    it 'can round-trip to XML' do
      xml = '<url>
              <loc>http://example.org/foo</loc>
              <lastmod>2006-06-06T06:00:00Z</lastmod>
              <changefreq>never</changefreq>
              <priority>0.12345</priority>
              <md at="2001-01-01T01:00:00Z" capability="resourcelist" change="updated" completed="2002-02-02T02:00:00Z"
                  encoding="utf-16" from="2003-03-03T03:00:00Z" hash="md5:1e0d5cb8ef6ba40c99b14c0237be735e" length="54321"
                  modified="2004-04-04T04:00:00Z" path="/foo" type="bar" until="2005-05-05T05:00:00Z"/>
              <ln encoding="utf-8" hash="md5:1e0d5cb8ef6ba40c99b14c0237be735e" href="http://example.org/" length="12345"
                  modified="2013-01-03T09:00:00Z" path="/foo/" pri="3.14159" rel="bar" type="baz"/>
              <ln encoding="utf-16" hash="sha-256:e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"
                  href="https://example.org/" length="54321" modified="2013-02-04T09:00:00Z" path="/foo/bar" pri="1.2345" rel="qux"
                  type="quux"/>
            </url>'
      url = parse(xml)
      expect(url.save_to_xml).to be_xml(xml)
    end
  end
end
