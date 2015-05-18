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
      end

      module MappingNodeMonkeyPatch
        class InheritanceAwareFallbackMapping

        end
      end

    end
  end
end
