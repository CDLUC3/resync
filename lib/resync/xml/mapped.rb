require 'uri'
require 'xml/mapping'

module Resync
  module XML
    # Mixin for XML-mapped objects, based on +::XML::Mapping+ with some
    # adjustments and extensions.
    module Mapped

      # Ensures that the provided value is a +URI+, parsing it if necessary.
      #
      # @param url [URI, String] the URI.
      # @raise [URI::InvalidURIError] if +url+ cannot be converted to a URI.
      def to_uri(url)
        return nil unless url
        (url.is_a? URI) ? url : URI.parse(url)
      end

      def self.included(base)
        base.include ::XML::Mapping
        base.extend ClassMethods
      end
      private_class_method :included

      # Defines methods that will become class methods on those
      # classes that include +Resync::XML::Mapped+
      module ClassMethods

        # Ensures that the provided value is a +REXML::Element+, parsing it or extracting
        # it from a document if necessary.
        #
        # @param xml [String, REXML::Document, REXML::Element] An XML element, in
        #   the form of a string or a parsed document/element
        # @return [REXML::Element] the parsed XML element, or the root element of the document
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

        # Fall back to +:_default_+ mapping when an unknown mapping is specified.
        # Overrides +::XML::Mapping::ClassMethods.xml_mapping_nodes+.
        def xml_mapping_nodes(mapping: nil, create: true)
          nodes = super(mapping: mapping, create: create)
          unless mapping == :_default
            nodes_by_name = nodes.map { |n| [n.instance_variable_get('@attrname'), n]}.to_h
            default_nodes = super(mapping: :_default, create: create)
            default_nodes.each do |n|
              name = n.instance_variable_get('@attrname')
              unless nodes_by_name.has_key?(name)
                nodes_by_name[name] = n
                nodes << n
              end
            end
          end
          nodes
        end

        private

        def valid_mapping(mapping)
          return mapping if xml_mapping_nodes_hash.key?(mapping)
          fail(::XML::MappingError, "undefined mapping: #{options[:mapping].inspect} for #{self}, and no :_default mapping found") unless xml_mapping_nodes_hash.key?(:_default)
          :_default
        end
      end

    end
  end
end
