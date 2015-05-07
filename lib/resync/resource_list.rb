module Resync
  class ResourceList
    attr_reader :resources
    attr_reader :metadata

    def initialize(resources: [], metadata: Metadata.new(capability: 'resourcelist'))
      @resources = resources
      @metadata = metadata_with_correct_capability(metadata)
    end

    # ------------------------------------------------------------
    # Private methods

    private

    # ------------------------------
    # Parameter validators

    def metadata_with_correct_capability(metadata)
      fail ArgumentError, "#{metadata} does not appear to be metadata" unless metadata.is_a?(Metadata)
      fail ArgumentError, "Wrong capability for ResourceList metadata; expected 'resourcelist', was '#{metadata.capability}'" unless metadata.capability == 'resourcelist'
      metadata
    end

  end
end
