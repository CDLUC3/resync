require 'spec_helper'

module Resync
  module XML
    describe Md do

      def parse(xml_string)
        doc = REXML::Document.new(xml_string)
        Md.load_from_xml(doc.root)
      end

      it 'parses a tag' do
        md = parse('<md/>')
        expect(md).to be_an(Md)
      end

      it 'parses a namespaced tag' do
        md = parse('<rs:md xmlns:rs="http://www.openarchives.org/rs/terms/"/>')
        expect(md).to be_an(Md)
      end

      it 'parses @at' do
        md = parse('<md at="2013-01-03T09:00:00Z"/>')
        expect(md.at).to eq(Time.utc(2013, 1, 3, 9))
      end

      it 'parses @capability' do
        md = parse('<md capability="resourcelist"/>')
        expect(md.capability).to eq('resourcelist')
      end

      it 'parses @change' do
        md = parse('<md change="deleted"/>')
        expect(md.change).to eq(Resync::Types::Change::DELETED)
      end

      it 'parses @completed' do
        md = parse('<md completed="2013-01-03T09:00:00Z"/>')
        expect(md.completed).to eq(Time.utc(2013, 1, 3, 9))
      end

      it 'parses @encoding' do
        md = parse('<md encoding="utf-8"/>')
        expect(md.encoding).to eq('utf-8')
      end

      it 'parses @from' do
        md = parse('<md from="2013-01-03T09:00:00Z"/>')
        expect(md.from).to eq(Time.utc(2013, 1, 3, 9))
      end

      describe 'parses @hash' do
        it 'parses a single value' do
          md = parse('<md hash="md5:1e0d5cb8ef6ba40c99b14c0237be735e"/>')
          expect(md.hashes).to eq('md5' => '1e0d5cb8ef6ba40c99b14c0237be735e')
        end

        it 'parses multiple values' do
          md = parse('<md hash="md5:1e0d5cb8ef6ba40c99b14c0237be735e
                                sha-256:854f61290e2e197a11bc91063afce22e43f8ccc655237050ace766adc68dc784"/>')
          expect(md.hashes).to eq('md5' => '1e0d5cb8ef6ba40c99b14c0237be735e', 'sha-256' => '854f61290e2e197a11bc91063afce22e43f8ccc655237050ace766adc68dc784')
        end
      end

      it 'parses @length' do
        md = parse('<md length="12345"/>')
        expect(md.length).to eq(12_345)
      end

      it 'parses @modified' do
        md = parse('<md modified="2013-01-03T09:00:00Z"/>')
        expect(md.modified).to eq(Time.utc(2013, 1, 3, 9))
      end

      it 'parses @path' do
        md = parse('<md path="/foo/bar"/>')
        expect(md.path).to eq('/foo/bar')
      end

      it 'parses @type' do
        mt = MIME::Types['text/plain'].first
        md = parse('<md type="text/plain"/>')
        expect(md.type).to eq(mt)
      end

      it 'parses @until' do
        md = parse('<md until="2013-01-03T09:00:00Z"/>')
        expect(md.until).to eq(Time.utc(2013, 1, 3, 9))
      end

      it 'can round-trip to XML' do
        xml = '<md
                at="2001-01-01T01:00:00Z"
                capability="resourcelist"
                change="updated"
                completed="2002-02-02T02:00:00Z"
                encoding="utf-16"
                from="2003-03-03T03:00:00Z"
                hash="md5:1e0d5cb8ef6ba40c99b14c0237be735e"
                length="54321"
                modified="2004-04-04T04:00:00Z"
                path="/foo"
                type="bar/baz"
                until="2005-05-05T05:00:00Z"
            />'
        md = parse(xml)
        expect(md.save_to_xml).to be_xml(xml)
      end
    end
  end
end
