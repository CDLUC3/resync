module Resync
  module XML
    # TODO: Stop having a parallel class hierarchy for the XML mapping

    # Adds XML conversions to the classes that include it. To use,
    # +include+ +Resync::XML::Convertible+ and define a constant
    # +XML_TYPE+ whose value is the +XML::Mapping+ mapping class
    # used to map to XML.
    module Convertible

      def self.included(base)
        base.extend XMLConversions
      end

      # Defines methods that will become class methods on those
      # classes that include +Resync+XML::Convertible+
      module XMLConversions
        def from_xml(xml)
          xml = ::Resync::XML.element(xml)
          load_from_xml(xml)
        end

        # Overrides +::XML::Mapping::ClassMethods.load_from_xml+ in order to
        # fall back to :_default mapping when an unknown mapping is specified;
        # this allows alternate mappings to include sub-elements that don't
        # know anything about the specified alternate mapping
        def load_from_xml(xml, options = { mapping: :_default })
          mapping = valid_mapping(options[:mapping])
          begin
            obj = new
          rescue ArgumentError
            obj = allocate
          end
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
