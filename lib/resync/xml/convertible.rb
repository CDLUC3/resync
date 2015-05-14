module Resync
  module XML

    # Adds XML conversions to the classes that include it. To use,
    # +include+ +Resync::XML::Convertible+ and define a constant
    # +XML_TYPE+ whose value is the +XML::Mapping+ mapping class
    # used to map to XML.
    module Convertible

      def self.included base
        base.extend XMLConversions
      end

      # Defines methods that will become class methods on those
      # classes that include +Resync+XML::Convertible+
      module XMLConversions

        # ------------------------------------------------------------
        # Public methods

        # Creates an instance of this class from the provided XML
        def from_xml(xml)
          mapped_instance = map(xml)
          self.new(mapped_instance.instance_variables.map do |name|
            [name.to_s.delete('@').to_sym, mapped_instance.instance_variable_get(name)]
          end.to_h)
        end

        # ------------------------------
        # Conversions

        private

        def map(xml)
          xml_type = self::XML_TYPE
          return xml if xml.is_a?(xml_type)
          xml_type.load_from_xml(::Resync::XML.element(xml))
        end
      end

    end
  end
end
