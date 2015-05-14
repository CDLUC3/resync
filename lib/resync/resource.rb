require_relative 'shared/link_collection'
require_relative 'xml'

module Resync
  class Resource
    include LinkCollection
    include XML::Convertible
    XML_TYPE = XML::Url

    # ------------------------------------------------------------
    # Attributes

    attr_reader :uri
    attr_reader :modified_time
    attr_reader :metadata
    attr_reader :changefreq
    attr_reader :priority

    # ------------------------------------------------------------
    # Initializer

    def initialize( # rubocop:disable Metrics/MethodLength, Metrics/ParameterLists
        uri:, modified_time: nil, changefreq: nil, priority: nil, links: nil, metadata: nil
    )
      @uri = to_uri(uri)
      @modified_time = modified_time
      @changefreq = changefreq
      @priority = priority

      @links = links || []
      @metadata = metadata
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

    # TODO: Share all of these
    def to_uri(url)
      (url.is_a? URI) ? url : URI.parse(url)
    end
  end
end
