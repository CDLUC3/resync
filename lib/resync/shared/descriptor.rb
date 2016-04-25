require 'mime/types'
require 'resync/xml'

module Resync
  # Base class for ResourceSync-specific elements describing a
  # resource or link.
  #
  # @!attribute [rw] modified_time
  #   @return [Time] the date and time when the referenced resource was last modified.
  # @!attribute [rw] length
  #   @return [Integer] the content length of the referenced resource.
  # @!attribute [rw] mime_type
  #   @return [MIME::Type] the media type of the referenced resource.
  # @!attribute [rw] encoding
  #   @return [String] the content encoding (if any) applied to the data in the
  #     referenced resource (e.g. for compression)
  # @!attribute [rw] hashes
  #   @return [Hash<String, String>] fixity information for the referenced
  #     resource, as a map from hash algorithm tokens (e.g. +md5+, +sha-256+)
  #     to hex-encoded digest values.
  # @!attribute [rw] path
  #   @return [String] for +ResourceDumpManifests+ and +ChangeDumpManifests+,
  #     the path to the referenced resource within the dump ZIP file.
  class Descriptor
    include ::XML::Mapping

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

    # Creates a new +Descriptor+ instance with the specified fields.
    #
    # @param modified_time [Time] The date and time when the referenced resource was last modified.
    # @param length [Integer] The content length of the referenced resource.
    # @param mime_type [MIME::Type] The media type of the referenced resource.
    # @param encoding [String] Any content encoding (if any) applied to the data in the
    #   referenced resource (e.g. for compression)
    # @param hashes [Hash<String, String>] Fixity information for the referenced
    #   resource, as a map from hash algorithm tokens (e.g. +md5+, +sha-256+)
    #   to hex-encoded digest values.
    # @param path [String] For +ResourceDumpManifests+ and +ChangeDumpManifests+,
    #   the path to the referenced resource within the dump ZIP file.
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
      @hashes = Descriptor.hash_of_hashcodes(value)
    end

    # ------------------------------------------------------------
    # Public methods

    # Gets the hash value for the specified algorithm.
    #
    # @param algorithm [String] The token (e.g. +md5+, +sha-256+) for the hash algorithm.
    # @return [String] The hex-encoded digest value.
    def hash(algorithm)
      hashes[algorithm]
    end

    # ------------------------------
    # Conversions

    def self.hash_of_hashcodes(hashes)
      return {} unless hashes
      return hashes if hashes.is_a?(Hash)
      hashes.split(/[[:space:]]+/).map { |hash| hash.split(':') }.to_h
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
