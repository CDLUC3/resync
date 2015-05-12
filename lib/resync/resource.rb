require_relative 'shared/link_collection'

module Resync
  class Resource
    include LinkCollection

    # ------------------------------------------------------------
    # Attributes

    attr_reader :uri
    attr_reader :modified_time
    attr_reader :metadata

    # ------------------------------------------------------------
    # Initializer

    def initialize(uri:, modified_time: nil, links: nil, metadata: nil)
      @uri = to_uri(uri)
      @modified_time = modified_time

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
