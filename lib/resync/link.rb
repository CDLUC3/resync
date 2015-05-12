module Resync

  # TODO: Share code with Metadata
  class Link
    # ------------------------------------------------------------
    # Attributes

    attr_reader :rel
    attr_reader :href

    attr_reader :priority

    attr_reader :modified_time

    attr_reader :length
    attr_reader :mime_type
    attr_reader :encoding
    attr_reader :hashes

    attr_reader :path

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
        hashes: {},

        path: nil
    )
      @rel = rel
      @href = to_uri(href)

      @priority = priority

      @modified_time = time_or_nil(modified_time)

      @length = natural_number_or_nil(length)
      @mime_type = mime_type_or_nil(mime_type)
      @encoding = encoding
      @hashes = hashes

      @path = path
    end

    # ------------------------------------------------------------
    # Public methods

    def hash(algorithm)
      hashes[algorithm]
    end

    # ------------------------------------------------------------
    # Private methods

    private

    # ------------------------------
    # Parameter validators

    def time_or_nil(time)
      fail ArgumentError, "time #{time} is not a Time" if time && !time.is_a?(Time)
      time
    end

    def natural_number_or_nil(value)
      fail ArgumentError, "value #{value} must be a non-negative integer" if value && (!value.is_a?(Integer) || value < 0)
      value
    end

    def mime_type_or_nil(mime_type)
      return nil unless mime_type
      return mime_type if mime_type.is_a?(MIME::Type)

      mt = MIME::Types[mime_type].first
      return mt if mt

      MIME::Type.new(mime_type)
    end

    # ------------------------------
    # Conversions

    # TODO: Share all of these
    def to_uri(url)
      (url.is_a? URI) ? url : URI.parse(url)
    end
  end
end
