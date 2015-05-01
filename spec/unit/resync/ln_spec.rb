require 'spec_helper'

module Resync

  describe Ln do

    def parse(xml_string)
      doc = REXML::Document.new(xml_string)
      Ln.load_from_xml(doc.root)
    end

    it 'parses a tag' do
      ln = parse('<ln/>')
      expect(ln).to be_an(Ln)
    end

    it 'parses a namespaced tag' do
      ln = parse('<rs:ln xmlns:rs="http://www.openarchives.org/rs/terms/"/>')
      expect(ln).to be_an(Ln)
    end

    it 'parses @encoding' do
      ln = parse('<ln encoding="utf-8"/>')
      expect(ln.encoding).to eq('utf-8')
    end

    it 'parses @hash' do
      ln = parse('<ln hash="md5:1e0d5cb8ef6ba40c99b14c0237be735e"/>')
      expect(ln.hash).to eq('md5:1e0d5cb8ef6ba40c99b14c0237be735e')
    end

    it 'parses @href' do
      ln = parse('<ln href="http://example.org/"/>')
      expect(ln.href).to eq(URI('http://example.org/'))
    end

    it 'parses @length' do
      ln = parse('<ln length="17"/>')
      expect(ln.length).to eq(17)
    end

    it 'parses @modified' do
      ln = parse('<ln modified="2013-01-03T09:00:00Z"/>')
      expect(ln.modified).to eq(Time.utc(2013, 1, 3, 9))
    end

    it 'parses @path' do
      ln = parse('<ln path="/foo"/>')
      expect(ln.path).to eq('/foo')
    end

    it 'parses @pri' do
      ln = parse('<ln pri="3.14159"/>')
      expect(ln.pri).to eq(3.14159)
    end

    it 'parses @rel' do
      ln = parse('<ln rel="elvis"/>')
      expect(ln.rel).to eq('elvis')
    end

    it 'parses @type' do
      ln = parse('<ln type="elvis"/>')
      expect(ln.type).to eq('elvis')
    end

    it 'can\'t be used as a hash key' do
      ln = parse('<ln hash="md5:1e0d5cb8ef6ba40c99b14c0237be735e"/>')
      expect do
        { ln => 'ln' }
      end.to raise_error(TypeError)
    end

  end

end
