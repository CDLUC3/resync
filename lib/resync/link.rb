module Resync
  class Link
    # ------------------------------------------------------------
    # Attributes

    attr_reader :rel
    attr_reader :href

    # ------------------------------------------------------------
    # Initializer

    def initialize(rel:, href:)
      @rel = rel
      @href = to_uri(href)
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
