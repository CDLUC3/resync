require 'mime/types'
require_relative '../xml'

module Resync
  class ResourceDescriptor
    include XML::Mapped

    # ------------------------------------------------------------
    # Attributes

    time_node :modified_time, '@modified', default_value: nil
    numeric_node :length, '@length', default_value: nil
    mime_type_node :mime_type, '@type', default_value: nil
    text_node :encoding, '@encoding', default_value: nil
    hash_codes_node :hashes, '@hash', default_value: nil
    text_node :path, '@path', default_value: nil

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
      self.modified_time = modified_time
      self.length = length
      self.mime_type = mime_type
      self.encoding = encoding
      self.hashes = hashes
      self.path = path
    end

    # ------------------------------------------------------------
    # Custom setters

    def modified_time=(value)
      @modified_time = time_or_nil(value)
    end

    def length=(value)
      @length = natural_number_or_nil(value)
    end

    def mime_type=(value)
      @mime_type = mime_type_or_nil(value)
    end

    def hashes=(value)
      @hashes = ResourceDescriptor.hash_of_hashcodes(value)
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

    def self.hash_of_hashcodes(hashes)
      return {} unless hashes
      return hashes if hashes.is_a?(Hash)
      hashes.split(/[[:space:]]+/).map { |hash| hash.split(':') }.to_h
    end
  end
end
