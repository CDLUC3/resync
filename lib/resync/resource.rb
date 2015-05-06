module Resync
  class Resource

    # ------------------------------------------------------------
    # Attributes

    attr_reader :uri

    # ------------------------------------------------------------
    # Initializer

    def initialize(uri:)
      @uri = to_uri(uri)
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
