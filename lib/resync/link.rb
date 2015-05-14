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
    # Factory method

    # TODO: If we're going to do this, what are the mapping classes getting us exactly? Maybe rename some attributes, automate?
    def self.from_xml(xml) # rubocop:disable Metrics/MethodLength
      ln = to_ln(xml)
      Link.new(
        rel: ln.rel,
        href: ln.href,
        priority: ln.pri,
        modified_time: ln.modified,
        length: ln.length,
        mime_type: ln.type,
        hashes: hash_of_hashcodes(ln.hash),
        path: ln.path
      )
    end

    # ------------------------------
    # Conversions

    def self.to_ln(xml)
      return xml if xml.is_a?(XML::Ln)
      XML::Ln.load_from_xml(XML.element(xml))
    end

    # TODO: Share all of these
    def to_uri(url)
      (url.is_a? URI) ? url : URI.parse(url)
    end

  end
end
