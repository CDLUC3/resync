require 'uri'
require 'time'
require 'xml/mapping'
require_relative 'types'

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
        fail ArgumentError, "Unexpected argument type; expected XML document, String, or IO source, was #{xml.class}" unless can_parse(xml)
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
    # Time

    # Maps +Time+ objects.
    class TimeNode < ::XML::Mapping::SingleAttributeNode
      def initialize(*args)
        path, *args = super(*args)
        @path = ::XML::XXPath.new(path)
        args
      end

      # Implements +::XML::Mapping::SingleAttributeNode#extract_attr_value+.
      def extract_attr_value(xml)
        value = default_when_xpath_err { @path.first(xml).text }
        value ? Time.iso8601(value).utc : nil
      end

      # Implements +::XML::Mapping::SingleAttributeNode#set_attr_value+.
      def set_attr_value(xml, value)
        @path.first(xml, ensure_created: true).text = value.iso8601
      end
    end

    ::XML::Mapping.add_node_class TimeNode

    # ------------------------------------------------------------
    # URI

    # Maps +URI+ objects.
    class UriNode < ::XML::Mapping::SingleAttributeNode
      def initialize(*args)
        path, *args = super(*args)
        @path = ::XML::XXPath.new(path)
        args
      end

      # Implements +::XML::Mapping::SingleAttributeNode#extract_attr_value+.
      def extract_attr_value(xml)
        val = default_when_xpath_err { @path.first(xml).text }
        URI(val.strip)
      end

      # Implements +::XML::Mapping::SingleAttributeNode#set_attr_value+.
      def set_attr_value(xml, value)
        @path.first(xml, ensure_created: true).text = value.to_s
      end
    end

    ::XML::Mapping.add_node_class UriNode

    # ------------------------------------------------------------
    # Resync::Types

    class EnumNode < ::XML::Mapping::SingleAttributeNode
      def initialize(*args)
        path, *args = super(*args)
        @path = ::XML::XXPath.new(path)
        args
      end

      # Implements +::XML::Mapping::SingleAttributeNode#extract_attr_value+.
      def extract_attr_value(xml)
        enumClass = self.class::ENUM_CLASS
        enumClass.parse(default_when_xpath_err { @path.first(xml).text })
      end

      # Implements +::XML::Mapping::SingleAttributeNode#set_attr_value+.
      def set_attr_value(xml, value)
        @path.first(xml, ensure_created: true).text = value.to_s
      end
    end

    # ------------------------------------------------------------
    # Resync::Types::Change

    # Maps +Resync::Types::Change+ values.
    class ChangeNode < EnumNode
      ENUM_CLASS = Resync::Types::Change
    end

    ::XML::Mapping.add_node_class ChangeNode

    # ------------------------------------------------------------
    # Resync::Types::Changefreq

    # Maps +Resync::Types::ChangeFrequency+ values.
    class ChangefreqNode < EnumNode
      ENUM_CLASS = Resync::Types::ChangeFrequency
    end

    ::XML::Mapping.add_node_class ChangefreqNode

    # ------------------------------------------------------------
    # MIME::Type

    # Maps +MIME::Type+ values.
    class MimeTypeNode < ::XML::Mapping::SingleAttributeNode
      def initialize(*args)
        path, *args = super(*args)
        @path = ::XML::XXPath.new(path)
        args
      end

      # Implements +::XML::Mapping::SingleAttributeNode#extract_attr_value+.
      def extract_attr_value(xml)
        mime_type = default_when_xpath_err { @path.first(xml).text }
        return nil unless mime_type
        return mime_type if mime_type.is_a?(MIME::Type)

        mt = MIME::Types[mime_type].first
        return mt if mt

        MIME::Type.new(mime_type)
      end

      # Implements +::XML::Mapping::SingleAttributeNode#set_attr_value+.
      def set_attr_value(xml, value)
        @path.first(xml, ensure_created: true).text = value.to_s
      end
    end

    ::XML::Mapping.add_node_class MimeTypeNode

    # ------------------------------------------------------------
    # Whitespace-separated hashcode list

    # Maps the whitespace-separated list of hash codes in a +<rs:ln>+
    # or +<rs:md>+ tag to a hash of digest values keyed by hash algorithm.
    # (See {Resync::Descriptor#hashes}.)
    class HashCodesNode < ::XML::Mapping::SingleAttributeNode
      def initialize(*args)
        path, *args = super(*args)
        @path = ::XML::XXPath.new(path)
        args
      end

      # Implements +::XML::Mapping::SingleAttributeNode#extract_attr_value+.
      def extract_attr_value(xml)
        hashes = default_when_xpath_err { @path.first(xml).text }
        return {} unless hashes
        return hashes if hashes.is_a?(Hash)
        hashes.split(/[[:space:]]+/).map { |hash| hash.split(':') }.to_h
      end

      # Implements +::XML::Mapping::SingleAttributeNode#set_attr_value+.
      def set_attr_value(xml, value)
        return if value.empty?
        hash_str = value.map { |k, v| "#{k}:#{v}" }.join(' ')
        @path.first(xml, ensure_created: true).text = hash_str
      end
    end

    ::XML::Mapping.add_node_class HashCodesNode

  end
end
