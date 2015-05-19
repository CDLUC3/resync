require_relative 'shared/link_collection'
require_relative 'xml'
require_relative 'metadata'

module Resync
  class Resource < LinkCollection
    include ::XML::Mapping
    include XML::Convertible

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

    # ------------------------------------------------------------
    # Private methods

    private

    # ------------------------------
    # Conversions

    # TODO: Share to_uri
    require 'uri'
    def to_uri(url)
      return nil unless url
      (url.is_a? URI) ? url : URI.parse(url)
    end
  end
end
