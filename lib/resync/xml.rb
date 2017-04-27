require 'uri'
require 'time'
require 'xml/mapping'
require 'xml/mapping_extensions'

require 'resync/types'

module Resync
  # Helper methods and modules related to reading and writing XML.
  module XML

    # ------------------------------------------------------
    # Module shared methods

    # Ensures that the provided value is a +URI+, parsing it if necessary.
    #
    # @param url [URI, String] the URI.
    # @raise [URI::InvalidURIError] if +url+ cannot be converted to a URI.
    def self.to_uri(url)
      return nil unless url
      return url if url.is_a? URI
      stripped = url.respond_to?(:strip) ? url.strip : url.to_s.strip
      URI.parse(stripped)
    end

    # Extracts a +REXML::Element+ from the specified object.
    #
    # @param xml [String, IO, REXML::Document, REXML::Element] A string or IO-like
    #   object containing an XML document (with or without XML declaration), or an
    #   XML document, or an XML element.
    # @return [REXML::Element] the root element of the document, or the element
    #   itself if +xml+ is already an element.
    def self.element(xml)
      case xml
      when REXML::Document
        xml.root
      when REXML::Element
        xml
      else
        raise ArgumentError, "Unexpected argument type; expected XML document, String, or IO source, was #{xml.class}" unless can_parse(xml)
        REXML::Document.new(xml).root
      end
    end

    # ------------------------------------------------------------
    # Private class methods

    # Whether the argument can be parsed as an +REXML::Document+
    #
    # @return [Boolean] true if +REXML::Document.new()+ should be able to parse
    #   the argument, false otherwise
    def self.can_parse(arg)
      arg.is_a?(String) ||
        (arg.respond_to?(:read) &&
            arg.respond_to?(:readline) &&
            arg.respond_to?(:nil?) &&
            arg.respond_to?(:eof?))
    end
    private_class_method :can_parse

    # ------------------------------------------------------------
    # Whitespace-separated hashcode list

    # Maps the whitespace-separated list of hash codes in a +<rs:ln>+
    # or +<rs:md>+ tag to a hash of digest values keyed by hash algorithm.
    # (See {Resync::Descriptor#hashes}.)
    class HashCodesNode < ::XML::MappingExtensions::NodeBase

      def to_value(xml_text)
        return {} unless xml_text
        return xml_text if xml_text.is_a?(Hash)
        xml_text.split(/[[:space:]]+/).map { |hash| hash.split(':') }.to_h
      end

      def to_xml_text(value)
        value.map { |k, v| "#{k}:#{v}" }.join(' ') if value && !value.empty?
      end
    end

    ::XML::Mapping.add_node_class HashCodesNode

  end
end
