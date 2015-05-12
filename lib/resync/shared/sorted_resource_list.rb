require_relative 'base_resource_list'

module Resync
  class SortedResourceList < BaseResourceList

    def initialize(resources: nil, links: nil, metadata: nil)
      super(resources: sorted(resources), links: links, metadata: metadata)
    end

    # ------------------------------------------------------------
    # Private methods

    private

    # ------------------------------
    # Conversions

    def sorted(resources)
      return nil unless resources
      resources.sort do |left, right|
        if left.modified_time && right.modified_time
          left.modified_time <=> right.modified_time
        else
          right.modified_time ? 1 : -1
        end
      end
    end

  end
end
