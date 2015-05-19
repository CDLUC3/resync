require 'spec_helper'
require_relative 'shared/uri_field_examples'
require_relative 'shared/link_collection_examples'

module Resync
  describe Resource do
    describe '#new' do

      describe 'uri' do
        def uri_field
          :uri
        end
        it_behaves_like 'a URI field'
      end

      describe 'modified_time' do
        it 'accepts a modified_time timestamp' do
          lastmod = Time.utc(1997, 7, 16, 19, 20, 30.45)
          resource = Resource.new(uri: 'http://example.org', modified_time: lastmod)
          expect(resource.modified_time).to be_time(lastmod)
        end

        it 'defaults to nil if no modified_time timestamp specified' do
          resource = Resource.new(uri: 'http://example.org')
          expect(resource.modified_time).to be_nil
        end
      end

      describe 'links' do
        def required_arguments
          { uri: 'http://example.org' }
        end
        it_behaves_like Augmented
      end

      describe 'metadata' do
        it 'accepts metadata' do
          md = Metadata.new
          resource = Resource.new(uri: 'http://example.org', metadata: md)
          expect(resource.metadata).to eq(md)
        end

        it 'defaults to nil if metadata not specified' do
          resource = Resource.new(uri: 'http://example.org')
          expect(resource.metadata).to be_nil
        end
      end

      describe 'changefreq' do
        it 'accepts a change frequency' do
          cf = Types::ChangeFrequency::DAILY
          resource = Resource.new(uri: 'http://example.org', changefreq: cf)
          expect(resource.changefreq).to eq(cf)
        end

        it 'defaults to nil if no change frequency specified' do
          resource = Resource.new(uri: 'http://example.org')
          expect(resource.changefreq).to be_nil
        end
      end

      describe 'priority' do
        it 'accepts a priority' do
          priority = 1.234
          resource = Resource.new(uri: 'http://example.org', priority: priority)
          expect(resource.priority).to eq(priority)
        end

        it 'defaults to nil if no priority specified' do
          resource = Resource.new(uri: 'http://example.org')
          expect(resource.priority).to be_nil
        end
      end
    end

    describe 'capability' do
      it 'extracts the capability from the metadata' do
        md = Metadata.new(capability: 'changelist')
        resource = Resource.new(uri: 'http://example.org', metadata: md)
        expect(resource.capability).to eq('changelist')
      end

      it 'returns nil if no metadata was specified' do
        resource = Resource.new(uri: 'http://example.org')
        expect(resource.capability).to be_nil
      end
    end

    describe 'XML conversion' do
      describe '#from_xml' do
        it 'parses an XML string' do
          xml = '<url xmlns="http://www.sitemaps.org/schemas/sitemap/0.9" xmlns:rs="http://www.openarchives.org/rs/terms/">
                    <loc>http://example.com/res1</loc>
                    <lastmod>2013-01-03T18:00:00Z</lastmod>
                    <rs:md change="updated"
                           hash="md5:1584abdf8ebdc9802ac0c6a7402c03b6"
                           length="8876"
                           type="text/html"/>
                    <rs:ln rel="duplicate"
                           pri="1"
                           href="http://mirror1.example.com/res1"
                           modified="2013-01-03T18:00:00Z"/>
                    <rs:ln rel="duplicate"
                           pri="2"
                           href="http://mirror2.example.com/res1"
                           modified="2013-01-03T18:00:00Z"/>
                    <rs:ln rel="duplicate"
                           pri="3"
                           href="gsiftp://gridftp.example.com/res1"
                           modified="2013-01-03T18:00:00Z"/>
                </url>'
          resource = Resource.from_xml(xml)
          expect(resource).to be_a(Resource)
          expect(resource.uri).to eq(URI('http://example.com/res1'))
          expect(resource.modified_time).to be_time(Time.utc(2013, 1, 3, 18))
          metadata = resource.metadata
          expect(metadata.change).to eq(Types::Change::UPDATED)
          expect(metadata.hash('md5')).to eq('1584abdf8ebdc9802ac0c6a7402c03b6')
          expect(metadata.length).to eq(8_876)
          expect(metadata.mime_type).to be_mime_type('text/html')
          links = resource.links
          expect(links.size).to eq(3)
          expected_uris = [URI('http://mirror1.example.com/res1'),
                           URI('http://mirror2.example.com/res1'),
                           URI('gsiftp://gridftp.example.com/res1')]

          (0..2).each do |i|
            ln = links[i]
            expect(ln.rel).to eq('duplicate')
            expect(ln.priority).to eq(i + 1)
            expect(ln.href).to eq(expected_uris[i])
            expect(ln.modified_time).to be_time(Time.utc(2013, 1, 3, 18))
          end
        end
      end

      it 'can round-trip to XML' do
        data = '<url xmlns="http://www.sitemaps.org/schemas/sitemap/0.9" xmlns:rs="http://www.openarchives.org/rs/terms/">
                    <loc>http://example.com/res1</loc>
                    <lastmod>2013-01-03T18:00:00Z</lastmod>
                    <changefreq>daily</changefreq>
                    <rs:ln rel="duplicate"
                           pri="1"
                           href="http://mirror1.example.com/res1"
                           modified="2013-01-03T18:00:00Z"/>
                    <rs:ln rel="duplicate"
                           pri="2"
                           href="http://mirror2.example.com/res1"
                           modified="2013-01-03T18:00:00Z"/>
                    <rs:md change="updated"
                           hash="md5:1584abdf8ebdc9802ac0c6a7402c03b6"
                           length="8876"
                           type="text/html"/>
                    <rs:ln rel="duplicate"
                           pri="3"
                           href="gsiftp://gridftp.example.com/res1"
                           modified="2013-01-03T18:00:00Z"/>
                </url>'
        resource = Resource.from_xml(data)

        # Since resource isn't a root element, these won't be hacked in as in BaseResourceList#pre_save()
        xml = resource.save_to_xml
        xml.add_namespace('http://www.sitemaps.org/schemas/sitemap/0.9')
        xml.add_namespace('rs', 'http://www.openarchives.org/rs/terms/')

        expect(xml).to be_xml(data)
      end
    end
  end
end
