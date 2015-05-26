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
  #   @return [Array<Resource>] the +<url>+ or +<sitemap>+ elements contained in this list.
  class BaseResourceList < Augmented
    include ::XML::Mapping

    # ------------------------------------------------------------
    # Attributes

    root_element_name 'urlset'
    array_node :resources, 'url', class: Resource, default_value: []

    # ------------------------------------------------------------
    # Initializer

    # Creates a new +BaseResourceList+.
    #
    # @param resources [Array<Resource>] The +<url>+ or +<sitemap>+ elements contained in this list.
    # @param links [Array<Link>] Related links (+<rs:ln>+).
    # @param metadata [Metadata] Metadata about this list. The +capability+ of the metadata must match this
    #   implementation class' +CAPABILITY+ constant.
    # @raise [ArgumentError] if the specified metadata does not have the correct +capability+ attribute for this list type.
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
    # Custom getters

    def capability
      @metadata.capability
    end

    # Finds resources with the specified capability.
    # @param capability [String] the capability.
    # @return [Array<Resource>] those resources having that capability, or an empty array if none exist.
    def resources_for(capability:)
      resources.select { |l| l.capability == capability }
    end

    # Shortcut to find the first resource with the specified capability (in ResourceSync there often
    # should be only one resource with a particular capability)
    # @param capability [String] the capability.
    # @return [Resource] the first resource having that capability, or nil if none exists.
    def resource_for(capability:)
      resources.find { |l| l.capability == capability }
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
      fail ArgumentError, "Missing constant #{self.class}::CAPABILITY" unless capability
      return Metadata.new(capability: capability) unless metadata
      fail ArgumentError, "#{metadata} does not appear to be metadata" unless metadata.respond_to?('capability')
      fail ArgumentError, "Wrong capability for #{self.class.name} metadata; expected '#{capability}', was '#{metadata.capability}'" unless metadata.capability == capability
      metadata
    end

  end
end
