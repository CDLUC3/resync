module Resync
  class Resource

    # ------------------------------------------------------------
    # Attributes

    attr_reader :uri
    attr_reader :lastmod
    attr_reader :metadata

    # ------------------------------------------------------------
    # Initializer

    def initialize(uri:, lastmod: nil, metadata: nil)
      @uri = to_uri(uri)
      @lastmod = lastmod
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
