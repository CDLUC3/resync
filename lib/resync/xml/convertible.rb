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

        # Overrides +::XML::Mapping::ClassMethods.load_from_xml+ in order to
        # fall back to :_default mapping when an unknown mapping is specified;
        # this allows alternate mappings to include sub-elements that don't
        # know anything about the specified alternate mapping
        def base.load_from_xml(xml, options={ mapping: :_default })
          mapping = options[:mapping]
          unless xml_mapping_nodes_hash.has_key?(mapping)
            raise(::XML::MappingError, "undefined mapping: #{options[:mapping].inspect} for #{self}, and no :_default mapping found") unless xml_mapping_nodes_hash.has_key?(:_default)
            mapping = :_default
          end
          begin
            obj = self.new
          rescue ArgumentError
            obj = self.allocate
          end
          obj.initialize_xml_mapping mapping: mapping
          obj.fill_from_xml xml, mapping: mapping
          obj
        end

        # def to_xml(options:{ mapping: :_default })
        #   xml = save_to_xml(options)
        #   formatter = REXML::Formatters::Pretty.new(2)
        #   formatter.compact = true
        #   out = StringIO.new
        #   formatter.write(xml, out)
        #   out.string
        # end
      end

      # Defines methods that will become class methods on those
      # classes that include +Resync+XML::Convertible+
      module XMLConversions
        def from_xml(xml)
          xml = ::Resync::XML.element(xml)
          load_from_xml(xml)
        end
      end

    end
  end
end
