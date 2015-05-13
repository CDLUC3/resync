require_relative 'shared/resource_descriptor'

module Resync

  class Link < ResourceDescriptor
    # ------------------------------------------------------------
    # Attributes

    attr_reader :rel
    attr_reader :href
    attr_reader :priority

    # ------------------------------------------------------------
    # Initializer

    def initialize( # rubocop:disable Metrics/MethodLength, Metrics/ParameterLists
        rel:,
        href:,

        priority: nil,

        modified_time: nil,

        length: nil,
        mime_type: nil,
        encoding: nil,
        hashes: nil,

        path: nil
    )
      super(modified_time: modified_time, length: length, mime_type: mime_type, encoding: encoding, hashes: hashes, path: path)

      @rel = rel
      @href = to_uri(href)
      @priority = priority
    end

    # ------------------------------
    # Conversions

    # TODO: Share all of these
    def to_uri(url)
      (url.is_a? URI) ? url : URI.parse(url)
    end
  end
end
