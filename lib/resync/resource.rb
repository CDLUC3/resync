module Resync
  class Resource

    # ------------------------------------------------------------
    # Attributes

    attr_reader :uri
    attr_reader :metadata
    attr_reader :lastmod

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

    def to_uri(url)
      (url.is_a? URI) ? url : URI.parse(url)
    end
  end
end
