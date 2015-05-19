require_relative '../link'
require_relative '../metadata'

module Resync
  class LinkCollection
    include ::XML::Mapping

    # ------------------------------------------------------------
    # Attributes

    array_node :links, 'ln', class: Link, default_value: []
    object_node :metadata, 'md', class: Metadata, default_value: nil

    use_mapping :sitemapindex
    array_node :links, 'ln', class: Link, default_value: []
    object_node :metadata, 'md', class: Metadata, default_value: nil

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
