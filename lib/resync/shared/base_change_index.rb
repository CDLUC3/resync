require 'resync/shared/sorted_resource_list'

module Resync
  # Adds useful methods to {ChangeListIndex}, {ChangeDumpIndex}, and {ChangeDump}.
  class BaseChangeIndex < SortedResourceList
    # Filters the list of change lists by from/until time. The filter can be *strict*, in which
    # case only those change lists provably in the range are included, or *non-strict*, in which
    # case only those change lists provably *not* in the range are *excluded*. (This is particularly
    # useful for {ChangeDump}s, where the +from_time+ and +until_time+ attributes on the individual
    # bitstream packages are optional.)
    #
    # @param in_range [Range<Time>] the range of times to filter by
    # @param strict [Boolean] +true+ if resources without +from_time+ or +until_time+ should be
    #   excluded, +false+ if they should be included.
    # @return [Array<Resource>] those change lists whose +from_time+ *or* +until_time+
    #   falls within +in_range+
    def change_lists(in_range:, strict: true)
      resources.select do |r|
        strict ? strictly(in_range, r) : loosely(in_range, r)
      end
    end

    private

    def strictly(in_range, resource)
      from_in_range = resource.from_time ? in_range.cover?(resource.from_time) : false
      until_in_range = resource.until_time ? in_range.cover?(resource.until_time) : false
      from_in_range || until_in_range
    end

    def loosely(in_range, resource)
      (resource.from_time || resource.until_time) ? strictly(in_range, resource) : true
    end
  end
end
