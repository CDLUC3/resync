require_relative '../link'
require_relative '../metadata'

module Resync

  class LinkCollection
    include XML::Mapped

    # ------------------------------------------------------------
    # Constants

    # TODO: Clean this up and make it a method or something
    PREFIXIZER = proc do |obj, xml, default_obj_to_xml|
      default_obj_to_xml.call(obj, xml)
      xml.each_element do |e|
        case e.name
        when 'ln'
          e.name = 'rs:ln'
        when 'md'
          e.name = 'rs:md'
        end
      end
    end

    # ------------------------------------------------------------
    # Attributes

    array_node :links, 'ln', class: Link, default_value: [], writer: PREFIXIZER
    object_node :metadata, 'md', class: Metadata, default_value: nil, writer: PREFIXIZER

    use_mapping :sitemapindex
    array_node :links, 'ln', class: Link, default_value: [], writer: PREFIXIZER
    object_node :metadata, 'md', class: Metadata, default_value: nil, writer: PREFIXIZER

    # ------------------------------------------------------------
    # Initializer

    def initialize(links: nil)
      self.links = links
    end

    # ------------------------------------------------------------
    # Custom setters

    def links=(value)
      @links = value || []
    end

  end
end
