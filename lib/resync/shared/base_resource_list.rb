require_relative 'link_collection'
require_relative '../resource'
require_relative '../metadata'

module Resync
  class BaseResourceList < LinkCollection
    include ::XML::Mapping

    # ------------------------------------------------------------
    # Attributes

    root_element_name 'urlset'
    array_node :resources, 'url', class: Resource, default_value: []

    use_mapping :sitemapindex
    root_element_name 'sitemapindex'
    array_node :resources, 'sitemap', class: Resource, default_value: []

    def self.inherited(base)
      base.use_mapping :_default
      base.root_element_name 'urlset'
      base.use_mapping :sitemapindex
      base.root_element_name 'sitemapindex'
    end

    def pre_save(options={mapping: :_default})
      xml = super
      xml.add_namespace('http://www.sitemaps.org/schemas/sitemap/0.9')
      xml.add_namespace('rs', 'http://www.openarchives.org/rs/terms/')
      xml
    end

    # ------------------------------------------------------------
    # Initializer

    def initialize(resources: nil, links: nil, metadata: nil)
      super(links: links)
      self.resources = resources
      self.metadata = metadata
    end

    # ------------------------------------------------------------
    # Custom setters

    def resources=(value)
      @resources = value || []
    end

    def metadata=(value)
      @metadata = metadata_with_correct_capability(value)
    end

    # ------------------------------------------------------------
    # Private methods

    private

    # ------------------------------
    # Parameter validators

    def metadata_with_correct_capability(metadata)
      capability = self.class::CAPABILITY
      return Metadata.new(capability: capability) unless metadata
      fail ArgumentError, "#{metadata} does not appear to be metadata" unless metadata.respond_to?('capability')
      fail ArgumentError, "Wrong capability for #{self.class.name} metadata; expected '#{capability}', was '#{metadata.capability}'" unless metadata.capability == capability
      metadata
    end
  end
end
