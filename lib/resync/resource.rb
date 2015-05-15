require_relative 'shared/link_collection'
require_relative 'xml'
require_relative 'metadata'

module Resync
  class Resource < LinkCollection
    include ::XML::Mapping
    include XML::Convertible
    XML_TYPE = XML::Url

    # ------------------------------------------------------------
    # Attributes

    uri_node :uri, 'loc', default_value: nil
    time_node :modified_time, 'lastmod', default_value: nil
    changefreq_node :changefreq, 'changefreq', default_value: nil
    numeric_node :priority, 'priority', default_value: nil
    # TODO: is everything with :metadata also a LinkCollection? probably
    object_node :metadata, 'md', class: Metadata, default_value: nil

    # ------------------------------------------------------------
    # Initializer

    def initialize( # rubocop:disable Metrics/MethodLength, Metrics/ParameterLists
        uri:, modified_time: nil, changefreq: nil, priority: nil, links: nil, metadata: nil
    )
      self.uri = uri
      self.modified_time = modified_time
      self.changefreq = changefreq
      self.priority = priority
      self.links = links
      self.metadata = metadata
    end

    # ------------------------------------------------------------
    # Custom setters

    def uri=(value)
      @uri = to_uri(value)
    end

    def links=(value)
      @links = value || []
    end

    # ------------------------------------------------------------
    # Public methods

    def capability
      metadata ? metadata.capability : nil
    end

    # ------------------------------------------------------------
    # Private methods

    private

    # ------------------------------
    # Conversions

    # TODO: Share to_uri
    def to_uri(url)
      return nil unless url
      (url.is_a? URI) ? url : URI.parse(url)
    end
  end
end
