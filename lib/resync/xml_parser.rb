module Resync

  # Parses ResourceSync XML documents and returns appropriate objects.
  module XMLParser

    # The list of parseable +<urlset>+ types.
    URLSET_TYPES = [
      CapabilityList,
      ChangeDump,
      ChangeDumpManifest,
      ChangeList,
      ResourceDump,
      ResourceDumpManifest,
      ResourceList,
      SourceDescription
    ]
    private_constant :URLSET_TYPES

    # The list of parseable +<sitemapindex>+ types.
    SITEMAPINDEX_TYPES = [
      ChangeListIndex,
      ResourceListIndex
    ]
    private_constant :SITEMAPINDEX_TYPES

    CAPABILITY_ATTRIBUTE = "/*/[namespace-uri() = 'http://www.openarchives.org/rs/terms/' and local-name() = 'md']/@capability"
    private_constant :CAPABILITY_ATTRIBUTE

    # Parses the specified ResourceSync document and returns the appropriate object
    # based on the +capability+ attribute of the root element's metadata (i.e. +<rs:md>+).
    #
    # @param xml [String, REXML::Document, REXML::Element] a ResourceSync XML document
    #   (or its root element)
    def self.parse(xml:)
      root_element = XML.element(xml)
      mapping, types = root_element.name == 'sitemapindex' ? [:sitemapindex, SITEMAPINDEX_TYPES] : [:_default, URLSET_TYPES]
      root_type = root_type_for(types, root_element)
      root_type.load_from_xml(root_element, mapping: mapping)
    end

    def self.root_type_for(types, root_element)
      capability = capability_for(root_element)
      root_type = types.find { |t| t::CAPABILITY == capability }
      fail ArgumentError, "no mapped type for capability '#{capability}'" unless root_type
      root_type
    end

    private_class_method :root_type_for

    def self.capability_for(root_element)
      capability = capability_attribute_for(root_element).value
      fail ArgumentError, "unable to identify capability of root element in #{root_element}" unless capability
      capability
    end

    private_class_method :capability_for

    def self.capability_attribute_for(root_element)
      capability_attr = REXML::XPath.first(root_element, CAPABILITY_ATTRIBUTE)
      fail ArgumentError, "unable to identify capability of root element in #{root_element}" unless capability_attr
      capability_attr
    end

    private_class_method :capability_attribute_for
  end
end
