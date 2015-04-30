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

    it 'parses encoding' do
      ln = parse('<ln encoding="utf-8"/>')
      expect(ln.encoding).to eq('utf-8')
    end
  end
end
