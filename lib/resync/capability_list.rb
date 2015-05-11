require_relative 'shared/base_resource_list'

module Resync
  class CapabilityList < BaseResourceList
    CAPABILITY = 'capabilitylist'

    attr_reader :source_description

    def initialize(resources: nil, metadata: nil, source_description:)
      @source_description = to_uri(source_description)
      @capabilities = to_capability_map(resources)
      super(resources: @capabilities.values, metadata: metadata)
    end

    # ------------------------------------------------------------
    # Public methods

    def resource_for(capability:)
      @capabilities[capability]
    end

    # ------------------------------------------------------------
    # Private methods

    private

    # ------------------------------
    # Conversions

    def to_uri(url)
      (url.is_a? URI) ? url : URI.parse(url)
    end

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

  end
end
