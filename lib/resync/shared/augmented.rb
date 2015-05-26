require_relative '../link'
require_relative '../metadata'

module Resync

  # Base class for elements augmented with ResourceSync-specific child elements.
  #
  # @!attribute [rw] links
  #   @return [Array<Link>] related links.
  # @!attribute [rw] metadata
  #   @return [Metadata] metadata about this object.
  class Augmented
    include ::XML::Mapping

    # ------------------------------------------------------------
    # Class methods

    # ResourceSync-specific tags needing to be prefixed with +rs+ on output
    RS_TAGS = Set['ln', 'md']
    private_constant :RS_TAGS

    # Adds the +rs+ namespace prefix
    def self.prefix_rewriter(obj, xml, default_obj_to_xml)
      default_obj_to_xml.call(obj, xml)
      xml.each_element do |e|
        e.name = "rs:#{e.name}" if RS_TAGS.include?(e.name)
      end
    end
    private_class_method :prefix_rewriter

    # ------------------------------------------------------------
    # Attributes

    array_node :links, 'ln', class: Link, default_value: [], writer: method(:prefix_rewriter)
    object_node :metadata, 'md', class: Metadata, default_value: nil, writer: method(:prefix_rewriter)

    use_mapping :sitemapindex
    array_node :links, 'ln', class: Link, default_value: [], writer: method(:prefix_rewriter), sub_mapping: :_default
    object_node :metadata, 'md', class: Metadata, default_value: nil, writer: method(:prefix_rewriter), sub_mapping: :_default

    # ------------------------------------------------------------
    # Initializer

    # Creates a new +Augmented+ instance with the specified links and metadata.
    #
    # @param links [Array<Link>] related links (i.e. +<rs:ln>+).
    # @param metadata [Metadata] metadata about this resource.
    def initialize(links: [], metadata: nil)
      self.links = links
      self.metadata = metadata
    end

    # ------------------------------------------------------------
    # Custom accessors

    # Sets the +links+ list. +nil+ is treated as an empty list.
    def links=(value)
      @links = value || []
    end

    # Finds links with the specified relation.
    # @param rel [String] the relation.
    # @return [Array<Link>] those links having that relation, or an empty array if none exist.
    def links_for(rel:)
      links.select { |l| l.rel == rel }
    end

    # Shortcut to find the first link with the specified relation (in ResourceSync there often
    # should be only one link with a particular relation)
    # @param rel [String] the relation.
    # @return [Link] the first link having that relation, or nil if none exists.
    def link_for(rel:)
      links.find { |l| l.rel == rel }
    end
  end
end
