module Resync
  class Resource

    # ------------------------------------------------------------
    # Attributes

    attr_reader :uri
    attr_reader :metadata

    # ------------------------------------------------------------
    # Initializer

    def initialize(uri:, metadata: nil)
      @uri = to_uri(uri)
      @metadata = metadata
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
