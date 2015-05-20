require_relative 'shared/base_resource_list'
require_relative 'xml'

module Resync
  # A capability list. See section 9,
  # "{http://www.openarchives.org/rs/1.0/resourcesync#CapabilityList Advertising Capabilities}",
  # in the ResourceSync specification.
  #
  # @!attribute [rw] source_description
  #   @return [Link] a link to the description of the source whose capabilities are identified
  #     by this list. See section 8,
  #     "{http://www.openarchives.org/rs/1.0/resourcesync#SourceDesc Describing the Source}",
  #     in the ResourceSync specification.
  class CapabilityList < BaseResourceList
    include XML::Mapped

    # The capability provided by this type.
    CAPABILITY = 'capabilitylist'

    attr_reader :source_description

    # ------------------------------------------------------------
    # Initializer

    # Creates a new +BaseResourceList+.
    #
    # @param resources [Array<Resource>] The +<url>+ or +<sitemap>+ elements contained in this list.
    #   All resources must have a capability, and there can be no more than one resource for each
    #   specified capability.
    # @param links [Array<Link>] Related links (+<rs:ln>+).
    # @param metadata [Metadata] Metadata about this list. The +capability+ of the metadata must
    #   be +'capabilitylist'+.
    # @raise [ArgumentError] if a provided resource does not have a +capability+ attribute.
    # @raise [ArgumentError] if more than one provided resource has the same +capability+ attribute.
    # @raise [ArgumentError] if the specified metadata does not have the correct +capability+ attribute.
    def initialize(resources: [], links: [], metadata: nil)
      @source_description = source_description_from(links)
      @capabilities = to_capability_map(resources)
      super(resources: @capabilities.values, links: links, metadata: metadata)
    end

    # ------------------------------------------------------------
    # Public methods

    # Gets the resource for the specified capability.
    #
    # @param capability [String] The capability.
    # @return [Resource] the resource providing the capability, or +nil+ if
    #   there is no resource with that capability in this list.
    def resource_for(capability:)
      @capabilities[capability]
    end

    # ------------------------------------------------------------
    # Private methods

    private

    # ------------------------------
    # Conversions

    def to_capability_map(resources)
      capabilities = {}
      (resources || []).each do |resource|
        capability = resource.capability
        fail ArgumentError, "No capability found for resource with URI #{resource.uri}" unless capability
        fail ArgumentError, "Duplicate resource for capability #{capability}" if capabilities.key?(capability)
        capabilities[capability] = resource
      end
      capabilities
    end

    def source_description_from(links)
      return nil unless links
      desc = links.map { |link| link.href if link.rel == 'up' }.compact.first
      fail ArgumentError, "No source descrption (<link rel='up'/>) provided" unless desc
      desc
    end
  end
end
