require_relative 'shared/augmented'
require_relative 'xml'
require_relative 'metadata'

module Resync
  # A resource (i.e., +<url>+ or +<sitemap>+). See section 7,
  # {http://www.openarchives.org/rs/1.0/resourcesync#DocumentFormats Sitemap Document Formats},
  # in the ResourceSync specification.
  #
  class Resource < Augmented
    include ::XML::Mapping

    # ------------------------------------------------------------
    # Attributes

    root_element_name 'url'

    uri_node :uri, 'loc', default_value: nil
    time_node :modified_time, 'lastmod', default_value: nil
    changefreq_node :changefreq, 'changefreq', default_value: nil
    numeric_node :priority, 'priority', default_value: nil

    # ------------------------------------------------------------
    # Initializer

    # @param modified_time [Time] The date and time when the referenced resource was last modified.
    # @param changefreq [ChangeFrequency] how frequently the referenced resource is likely to change.
    # @param priority [Number] the priority of this resource relative to other resources from the
    #   same provider. Allows robots to decide which resources to crawl or harvest.
    #   Values should be in the range 0-1.0 (inclusive), where 0 is the lowest priority
    #   and 1.0 is the highest.
    # @param links [Array<Link>] related links (i.e. +<rs:ln>+).
    # @param metadata [Metadata] metadata about this resource.
    def initialize( # rubocop:disable Metrics/MethodLength, Metrics/ParameterLists
        uri:,
        modified_time: nil,
        changefreq: nil,
        priority: nil,
        links: [],
        metadata: nil
    )
      super(links: links)
      self.uri = uri
      self.modified_time = modified_time
      self.changefreq = changefreq
      self.priority = priority
      self.metadata = metadata
    end

    # ------------------------------------------------------------
    # Custom setters

    def uri=(value)
      @uri = XML.to_uri(value)
    end

    # ------------------------------------------------------------
    # Public methods

    def capability
      metadata ? metadata.capability : nil
    end

    # ------------------------------------------------------------
    # Overrides

    # ResourceSync schema requires '##other' elements to appear last
    def self.all_xml_mapping_nodes(options = { mapping: nil, create: true })
      xml_mapping_nodes(options) + superclass.all_xml_mapping_nodes(options)
    end

  end
end
