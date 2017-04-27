require 'resync/shared/descriptor'
require 'resync/xml'

module Resync

  # A link to a related resource. See "Linking to Related Resources"
  # under section 5.1,
  # {http://www.openarchives.org/rs/1.0/resourcesync#SourcePers Synchronization Processes: Source Perspective}
  # in the ResourceSync specification.
  #
  # @!attribute [rw] rel
  #   @return [String] the relationship of the linked resource to the original
  #     resource. See {http://tools.ietf.org/html/rfc5988 RFC 5988}, "Web Linking".
  #     for information on link relation types.
  # @!attribute [rw] uri
  #   @return [URI] the URI of the linked resource.
  # @!attribute [rw] priority
  #   @return [Integer] the priority of the linked resource among links with the
  #     same relation type. Values should be in the range 1-999,999 (inclusive).
  #     Lower values indicate higher priorities.
  class Link < Descriptor
    include ::XML::Mapping

    # ------------------------------------------------------------
    # Attributes

    root_element_name 'ln'

    text_node :rel, '@rel', default_value: nil
    uri_node :uri, '@href', default_value: nil
    numeric_node :priority, '@pri', default_value: nil

    # ------------------------------------------------------------
    # Initializer

    # @param rel [String] the relationship of the linked resource to the
    #   original resource. See {http://tools.ietf.org/html/rfc5988 RFC 5988},
    #   "Web Linking". for information on link relation types.
    # @param uri [URI] the URI of the linked resource.
    # @param priority [Integer] the priority of the linked resource among links
    #   with the same relation type. Values should be in the range
    #   1-999,999 (inclusive). Lower values indicate higher priorities.
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
    # @raise [URI::InvalidURIError] if +uri+ cannot be converted to a URI.
    def initialize( # rubocop:disable Metrics/ParameterLists
        rel:,
        uri:,

        priority: nil,

        modified_time: nil,

        length: nil,
        mime_type: nil,
        encoding: nil,
        hashes: {},

        path: nil
    )
      super(modified_time: modified_time, length: length, mime_type: mime_type, encoding: encoding, hashes: hashes, path: path)

      self.rel = rel
      self.uri = uri
      self.priority = priority
    end

    # ------------------------------------------------------------
    # Custom setters

    # Sets the URI of the linked resource. Strings will be converted to +URI+ objects.
    # @param value [URI, String] the URI.
    # @raise [URI::InvalidURIError] if +value+ cannot be converted to a URI.
    def uri=(value)
      @uri = XML.to_uri(value)
    end

  end
end
