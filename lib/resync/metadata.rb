require 'resync/shared/descriptor'
require 'resync/xml'

module Resync

  # Metadata about a resource or ResourceSync document. See section 7,
  # {http://www.openarchives.org/rs/1.0/resourcesync#DocumentFormats Sitemap Document Formats},
  # in the ResourceSync specification.
  #
  # @!attribute [rw] at_time
  #   @return [Time] the datetime at which assembling a resource list
  #     began (including resource list indices, resource dumps, etc.)
  # @!attribute [rw] from_time
  #   @return [Time] the beginning of the time range represented by
  #     a change list (including change list indices, change dumps, etc.)
  # @!attribute [rw] until_time
  #   @return [Time] the end of the time range represented by
  #     a change list (including change list indices, change dumps, etc.)
  # @!attribute [rw] completed_time
  #   @return the datetime at which assembling a resource list
  #     ended (including resource list indices, resource dumps, etc.)
  # @!attribute [rw] change
  #   @return [Change] the type of change to a resource reported in
  #     a change list (including change list indices, change dumps, etc.)
  # @!attribute [rw] capability
  #   @return [String] identifies the type of a ResourceSync document.
  class Metadata < Descriptor
    include ::XML::Mapping

    # ------------------------------------------------------------
    # Attributes

    root_element_name 'md'

    time_node :at_time, '@at', default_value: nil
    time_node :from_time, '@from', default_value: nil
    time_node :until_time, '@until', default_value: nil
    time_node :completed_time, '@completed', default_value: nil
    typesafe_enum_node :change, '@change', class: Types::Change, default_value: nil
    text_node :capability, '@capability', default_value: nil

    # ------------------------------------------------------------
    # Initializer

    # @param at_time [Time] the datetime at which assembling a resource list
    #   began (including resource list indices, resource dumps, etc.)
    # @param from_time [Time] the beginning of the time range represented by
    #   a change list (including change list indices, change dumps, etc.)
    # @param until_time [Time] the end of the time range represented by
    #   a change list (including change list indices, change dumps, etc.)
    # @param completed_time [Time] the datetime at which assembling a resource list
    #   ended (including resource list indices, resource dumps, etc.)
    # @param modified_time [Time] The date and time when the referenced resource was last modified.
    # @param length [Integer] The content length of the referenced resource.
    # @param mime_type [MIME::Type] The media type of the referenced resource.
    # @param encoding [String] Any content encoding (if any) applied to the data in the
    #   referenced resource (e.g. for compression)
    # @param hashes [Hash<String, String>] Fixity information for the referenced
    #   resource, as a map from hash algorithm tokens (e.g. +md5+, +sha-256+)
    #   to hex-encoded digest values.
    # @param change [Change] the type of change to a resource reported in
    #   a change list (including change list indices, change dumps, etc.)
    # @param capability [String] identifies the type of a ResourceSync document.
    # @param path [String] For +ResourceDumpManifests+ and +ChangeDumpManifests+,
    #   the path to the referenced resource within the dump ZIP file.
    def initialize( # rubocop:disable Metrics/ParameterLists
        at_time: nil,
        from_time: nil,
        until_time: nil,
        completed_time: nil,
        modified_time: nil,

        length: nil,
        mime_type: nil,
        encoding: nil,
        hashes: {},

        change: nil,
        capability: nil,
        path: nil
    )
      super(modified_time: modified_time, length: length, mime_type: mime_type, encoding: encoding, hashes: hashes, path: path)

      self.at_time = at_time
      self.from_time = from_time
      self.until_time = until_time
      self.completed_time = completed_time

      self.change = change
      self.capability = capability
    end

    # ------------------------------------------------------------
    # Custom setters

    def at_time=(value)
      @at_time = time_or_nil(value)
    end

    def from_time=(value)
      @from_time = time_or_nil(value)
    end

    def until_time=(value)
      @until_time = time_or_nil(value)
    end

    def completed_time=(value)
      @completed_time = time_or_nil(value)
    end
  end
end
