require_relative 'shared/descriptor'
require_relative 'xml'

module Resync

  class Link < Descriptor
    include XML::Mapped

    # ------------------------------------------------------------
    # Attributes

    root_element_name 'ln'

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

  end
end
