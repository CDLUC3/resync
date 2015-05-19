require_relative 'shared/resource_descriptor'
require_relative 'xml'

module Resync

  class Link < ResourceDescriptor
    include ::XML::Mapping
    include XML::Convertible

    # ------------------------------------------------------------
    # Attributes

    # explicit prefix hacked in b/c XML::Mapping doesn't understand namespaces
    root_element_name 'rs:ln'

    text_node :rel, '@rel', default_value: nil
    uri_node :href, '@href', default_value: nil
    numeric_node :priority, '@pri', default_value: nil

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

      self.rel = rel
      self.href = href
      self.priority = priority
    end

    # ------------------------------------------------------------
    # Custom setters

    def href=(value)
      @href = to_uri(value)
    end

    # ------------------------------
    # Conversions

    # TODO: Share to_uri
    require 'uri'
    def to_uri(url)
      return nil unless url
      (url.is_a? URI) ? url : URI.parse(url)
    end

  end
end
