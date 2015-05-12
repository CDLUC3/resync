require_relative 'link_collection'

module Resync
  class BaseResourceList
    include LinkCollection

    attr_reader :resources
    attr_reader :metadata

    def initialize(resources: nil, links: nil, metadata: nil)
      @resources = resources || []
      @links = links || []
      @metadata = metadata_with_correct_capability(metadata)
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
