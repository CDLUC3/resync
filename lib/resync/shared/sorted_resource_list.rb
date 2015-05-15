require_relative 'base_resource_list'

module Resync
  class SortedResourceList < BaseResourceList

    # ------------------------------------------------------------
    # Custom setters

    def resources=(value)
      @resources = sorted(value)
    end

    # ------------------------------------------------------------
    # Private methods

    private

    # ------------------------------
    # Conversions

    def sorted(resources)
      return [] unless resources
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
