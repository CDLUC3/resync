require_relative 'base_resource_list'

module Resync
  # An extension to +BaseResourceList+ for resource lists that
  # should be sorted by modification time.
  class SortedResourceList < BaseResourceList

    # ------------------------------------------------------------
    # Custom setters

    # Sets the +resources+ list, sorting the resources by modification
    # time. (+nil+ is treated as an empty list.) Resources without
    # modification times will be sorted to the end.
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
