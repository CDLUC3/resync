require 'spec_helper'
require_relative 'shared/uri_field_examples'
require_relative 'shared/descriptor_examples'

module Resync
  describe Link do

    def required_arguments
      { rel: 'describedby', href: 'http://example.org' }
    end

    it_behaves_like Descriptor

    describe '#new' do

      describe 'rel' do
        it 'accepts a relation' do
          rel = 'describedby'
          link = Link.new(rel: rel, href: 'http://example.org')
          expect(link.rel).to eq(rel)
        end

        it 'requires a relation' do
          expect { Link.new(href: 'http://example.org') }.to raise_error(ArgumentError)
        end
      end

      describe 'href' do
        def uri_field
          :href
        end

        it_behaves_like 'a URI field'
      end

      describe 'priority' do
        it 'accepts a priority' do
          priority = 1.234
          link = Link.new(rel: 'describedby', href: 'http://example.org', priority: priority)
          expect(link.priority).to eq(priority)
        end

        it 'defaults to nil if no priority specified' do
          link = Link.new(rel: 'describedby', href: 'http://example.org')
          expect(link.priority).to be_nil
        end
      end

    end

    describe 'XML conversion' do
      describe '#from_xml' do
        it 'parses an XML string' do
          xml = '<ln
                encoding="utf-8"
                hash="md5:1e0d5cb8ef6ba40c99b14c0237be735e"
                href="http://example.org/"
                length="12345"
                modified="2013-01-03T09:00:00Z"
                path="/foo/"
                pri="3.14159"
                rel="bar"
                type="baz/qux"
            />'
          link = Link.load_from_xml(XML.element(xml))
          expect(link).to be_a(Link)
          expect(link.rel).to eq('bar')
          expect(link.href).to eq(URI('http://example.org'))
          expect(link.priority).to eq(3.14159)
          expect(link.modified_time).to be_time(Time.utc(2013, 1, 3, 9))
          expect(link.length).to eq(12_345)
          expect(link.mime_type).to be_mime_type('baz/qux')
          expect(link.hash('md5')).to eq('1e0d5cb8ef6ba40c99b14c0237be735e')
          expect(link.path).to eq('/foo/')
        end
      end

      it 'can round-trip to XML' do
        data = '<ln
                encoding="utf-8"
                hash="md5:1e0d5cb8ef6ba40c99b14c0237be735e"
                href="http://example.org/"
                length="12345"
                modified="2013-01-03T09:00:00Z"
                path="/foo/"
                pri="3.14159"
                rel="bar"
                type="baz/qux"
            />'
        link = Link.load_from_xml(XML.element(data))
        xml = link.save_to_xml
        expect(xml).to be_xml(data)
      end

      it 'can round-trip to XML with the :sitemapindex mapping' do
        xml = ::Resync::XML.element('<ln
                encoding="utf-8"
                hash="md5:1e0d5cb8ef6ba40c99b14c0237be735e"
                href="http://example.org/"
                length="12345"
                modified="2013-01-03T09:00:00Z"
                path="/foo/"
                pri="3.14159"
                rel="bar"
                type="baz/qux"
            />')
        options = { mapping: :sitemapindex }
        link = Link.load_from_xml(xml, options)
        xml = link.save_to_xml(options)
        expect(xml).to be_xml(xml)
      end

    end
  end
end
