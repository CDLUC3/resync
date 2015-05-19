require_relative 'shared/augmented'
require_relative 'xml'
require_relative 'metadata'

module Resync
  class Resource < Augmented
    include XML::Mapped

    # ------------------------------------------------------------
    # Attributes

    root_element_name 'url'

    uri_node :uri, 'loc', default_value: nil
    time_node :modified_time, 'lastmod', default_value: nil
    changefreq_node :changefreq, 'changefreq', default_value: nil
    numeric_node :priority, 'priority', default_value: nil

    # ------------------------------------------------------------
    # Initializer

    def initialize( # rubocop:disable Metrics/MethodLength, Metrics/ParameterLists
        uri:, modified_time: nil, changefreq: nil, priority: nil, links: nil, metadata: nil
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
      @uri = to_uri(value)
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
