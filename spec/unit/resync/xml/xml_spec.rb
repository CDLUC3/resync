require 'spec_helper'

module Resync
  describe XML do
    describe '#element' do
      it 'returns an element unchanged' do
        elem = REXML::Element.new('foo')
        expect(XML.element(elem)).to be(elem)
      end

      it 'returns the root element of a string document' do
        xml_str = '<?xml version="1.0"?><foo><bar/><baz/></foo>'
        elem = XML.element(xml_str)
        expect(elem).to be_a(REXML::Element)
        expect(elem).to be_xml('<foo><bar/><baz/></foo>')
      end

      it 'returns the root element of a REXML::Document' do
        xml_str = '<?xml version="1.0"?><foo><bar/><baz/></foo>'
        doc = REXML::Document.new(xml_str)
        elem = XML.element(doc)
        expect(elem).to be_a(REXML::Element)
        expect(elem).to be_xml(doc.root)
      end

      it 'parses an XML fragment as an element' do
        xml_str = '<foo><bar/><baz/></foo>'
        elem = XML.element(xml_str)
        expect(elem).to be_a(REXML::Element)
        expect(elem).to be_xml(xml_str)
      end

      it 'fails when it gets something other than XML' do
        data = 12_345
        expect { XML.element(data) }.to raise_exception
      end

    end
  end
end
