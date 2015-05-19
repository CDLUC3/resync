require_relative 'augmented'
require_relative '../resource'
require_relative '../metadata'

module Resync
  # Base class for root elements containing a list of resources
  # (i.e., +<urlset>+ and +<sitemapindex>+ elements). Subclasses
  # must define a +CAPABILITY+ constant identifying the capability
  # they represent (e.g. +resourcelist+, +changelist+).
  #
  # @!attribute [rw] resources
  #   @return [Array<Resource>] The +<url>+ or +<sitemap>+ elements contained in this list.
  class BaseResourceList < Augmented
    include XML::Mapped

    # ------------------------------------------------------------
    # Attributes

    root_element_name 'urlset'
    array_node :resources, 'url', class: Resource, default_value: []

    use_mapping :sitemapindex
    root_element_name 'sitemapindex'
    array_node :resources, 'sitemap', class: Resource, default_value: []

    # ------------------------------------------------------------
    # Initializer

    # Creates a new +BaseResourceList+.
    #
    # @param resources [Array<Resource>] The +<url>+ or +<sitemap>+ elements contained in this list. (Optional;
    #   defaults to an empty array.)
    # @param links [Array<Link>] Related links (+<rs:ln>+). (Optional; defaults to an empty array.)
    # @param metadata [Metadata] Metadata about this list. The +capability+ of the metadata must match this
    #   implementation class' +CAPABILITY+ constant. (Optional; defaults to an otherwise empty metadata with
    #   the correct +capability+ attribute.)
    def initialize(resources: [], links: [], metadata: nil)
      super(links: links)
      self.resources = resources
      self.metadata = metadata
    end

    # ------------------------------------------------------------
    # Custom setters

    # Sets the +resources+ list. +nil+ is treated as an empty list.
    def resources=(value)
      @resources = value || []
    end

    # Sets the metadata.
    #
    # @raise [ArgumentError] if the specified metadata does not have the correct +capability+ attribute for
    #   this list type.
    def metadata=(value)
      @metadata = metadata_with_correct_capability(value)
    end

    # ------------------------------------------------------------
    # Overrides

    # Overrides +::XML::Mapping.pre_save+ to declare the Sitemap and ResourceSync namespaces.
    # Used for writing.
    def pre_save(options = { mapping: :_default })
      xml = super(options)
      xml.add_namespace('http://www.sitemaps.org/schemas/sitemap/0.9')
      xml.add_namespace('rs', 'http://www.openarchives.org/rs/terms/')
      xml
    end

    # Initializes the +:_default+ and +:sitemapindex+ mappings on all subclasses, and sets the corresponding
    # root element names (+<urlset>+ and +<sitemapindex>+)
    def self.inherited(base)
      base.use_mapping :_default
      base.root_element_name 'urlset'
      base.use_mapping :sitemapindex
      base.root_element_name 'sitemapindex'
    end

    # ------------------------------------------------------------
    # Private methods

    private

    # ------------------------------
    # Parameter validators

    # Validates the +capability+ attribute in the specified metadata.
    # @raise [ArgumentError] if the specified metadata does not have the correct +capability+ attribute for this list type.
    def metadata_with_correct_capability(metadata)
      capability = self.class::CAPABILITY
      return Metadata.new(capability: capability) unless metadata
      fail ArgumentError, "#{metadata} does not appear to be metadata" unless metadata.respond_to?('capability')
      fail ArgumentError, "Wrong capability for #{self.class.name} metadata; expected '#{capability}', was '#{metadata.capability}'" unless metadata.capability == capability
      metadata
    end

  end
end
