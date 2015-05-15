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

        # # ------------------------------------------------------------
        # # Public methods
        #
        # # Creates an instance of this class from the provided XML
        # def from_xml(xml)
        #   mapped_instance = map(xml)
        #   # TODO: Something less ugly cf. http://stackoverflow.com/a/30247578/27358
        #   hashed_fields = mapped_instance.instance_variables.map do |name|
        #     [name.to_s.delete('@').to_sym, map_value(mapped_instance.instance_variable_get(name))]
        #   end.to_h
        #   new(hashed_fields)
        #   # begin
        #   #   new(hashed_fields)
        #   # rescue ArgumentError => e
        #   #   puts self
        #   #   puts self::XML_TYPE
        #   #   puts mapped_instance
        #   #   puts hashed_fields
        #   #   raise e
        #   # end
        # end
        #
        # # ------------------------------
        # # Conversions
        #
        # private
        #
        # def map(xml)
        #   xml_type = self::XML_TYPE
        #   return xml if xml.is_a?(xml_type)
        #   xml_type.load_from_xml(::Resync::XML.element(xml))
        # end
        #
        # # TODO: a better hack for nested elements -- maybe register all conversions here, instead of class-by-class?
        # def map_value(xml) # rubocop:disable Metrics/MethodLength
        #   case xml
        #   when Ln
        #     Link.from_xml(xml)
        #   when Md
        #     Metadata.from_xml(xml)
        #   when Url
        #     Resource.from_xml(xml)
        #   when Array
        #     xml.map { |v| map_value(v) }
        #   else
        #     xml
        #   end
        # end
      end

    end
  end
end
