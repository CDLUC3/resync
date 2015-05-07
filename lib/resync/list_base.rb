module Resync
  class ListBase
    attr_reader :resources
    attr_reader :metadata

    def initialize(resources: nil, metadata: nil)
      @resources = resources ? resources : []
      @metadata = metadata_with_correct_capability(metadata)
    end

    # ------------------------------------------------------------
    # Private methods

    private

    def metadata_with_correct_capability(metadata)
      capability = self.class::CAPABILITY
      return Metadata.new(capability: capability) unless metadata
      fail ArgumentError, "#{metadata} does not appear to be metadata" unless metadata.respond_to?('capability')
      fail ArgumentError, "Wrong capability for #{self.class.name} metadata; expected '#{capability}', was '#{metadata.capability}'" unless metadata.capability == capability
      metadata
    end
  end
end
