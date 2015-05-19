
module Resync
  module XML

    # ------------------------------------------------------
    # Module shared methods

    # Extracts a +REXML::Element+ from the specified object.
    #
    # @param xml [String, REXML::Document, REXML::Element] A string containing
    #   an XML document (with or without XML declaration), or an XML document,
    #   or an XML element.
    # @return [REXML::Element] The root element of the document, or the element
    #   itself if +xml+ is already an element.
    def self.element(xml)
      case xml
      when String
        REXML::Document.new(xml).root
      when REXML::Document
        xml.root
      when REXML::Element
        xml
      else
        fail "Unexpected argument type; expected XML document, was #{xml.class}"
      end
    end

    # ------------------------------------------------------
    # Module files

    Dir.glob(File.expand_path('../xml/*.rb', __FILE__), &method(:require))
  end
end
