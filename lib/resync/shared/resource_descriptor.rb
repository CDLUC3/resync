require 'mime/types'

module Resync
  class ResourceDescriptor

    # ------------------------------------------------------------
    # Attributes

    attr_reader :modified_time
    attr_reader :length
    attr_reader :mime_type
    attr_reader :encoding
    attr_reader :hashes
    attr_reader :path

    # ------------------------------------------------------------
    # Initializer

    def initialize( # rubocop:disable Metrics/MethodLength, Metrics/ParameterLists
        modified_time: nil,
        length: nil,
        mime_type: nil,
        encoding: nil,
        hashes: nil,
        path: nil
    )
      @modified_time = time_or_nil(modified_time)
      @length = natural_number_or_nil(length)
      @mime_type = mime_type_or_nil(mime_type)
      @encoding = encoding
      @hashes = hashes || {}
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

  end
end
