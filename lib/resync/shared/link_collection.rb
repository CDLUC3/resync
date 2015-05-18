require_relative '../link'

module Resync
  class LinkCollection
    include ::XML::Mapping

    # ------------------------------------------------------------
    # Attributes

    array_node :links, 'ln', class: Link, default_value: []

    use_mapping :sitemapindex
    array_node :links, 'ln', class: Link, default_value: []

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
