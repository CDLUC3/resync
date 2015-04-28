require 'happymapper'

module Resync
  class NamespacedElement
    def self.inherited(base)
      base.include HappyMapper
      hm_parse = base.instance_method(:parse)

      base.send(:define_method, :parse) do |xml, options = {}|

        doc = if xml.is_a?(Nokogiri::XML::Document)
                xml
              elsif xml.is_a?(Nokogiri::XML::Node)
                xml.document
              else
                Nokogiri::XML.Document.parse(xml)
              end

        namespace_uri = base.namespace_uri
        namespaces = doc.collect_namespaces
        prefix = namespaces.invert[namespace_uri.to_s]
        if prefix && prefix.start_with?('xmlns:')
          prefix = prefix['xmlns:'.length..-1]
          base.namespace prefix
        end

        hm_parse.bind(self).call(doc, options)
      end
    end
  end
end

require 'bigdecimal'

module HappyMapper
  module SupportedTypes
    register_type BigDecimal do |value|
      BigDecimal.new(value)
    end

    register_type URI do |value|
      URI(value)
    end
  end
end

module Resync
  Dir.glob(File.expand_path('../resync/*.rb', __FILE__), &method(:require))
end

