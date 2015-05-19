require 'uri'
require 'xml/mapping'

module Resync
  module XML
    module Mapped

      def self.included(base)
        base.include ::XML::Mapping
        base.extend ClassMethods
      end

      def to_uri(url)
        return nil unless url
        (url.is_a? URI) ? url : URI.parse(url)
      end

      # Defines methods that will become class methods on those
      # classes that include +Resync::XML::Mapped+
      module ClassMethods

        def from_xml(xml)
          xml = ::Resync::XML.element(xml)
          load_from_xml(xml)
        end

        # Fall back to +:_default_+ mapping when an unknown mapping is specified.
        # Overrides +::XML::Mapping::ClassMethods.load_from_xml+.
        def load_from_xml(xml, options = { mapping: :_default })
          mapping = valid_mapping(options[:mapping])
          obj = allocate # bypass initializers with required arguments
          obj.initialize_xml_mapping mapping: mapping
          obj.fill_from_xml xml, mapping: mapping
          obj
        end

        def valid_mapping(mapping)
          return mapping if xml_mapping_nodes_hash.key?(mapping)
          fail(::XML::MappingError, "undefined mapping: #{options[:mapping].inspect} for #{self}, and no :_default mapping found") unless xml_mapping_nodes_hash.key?(:_default)
          :_default
        end
      end

    end
  end
end
