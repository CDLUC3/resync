require_relative 'sorted_resource_list'

module Resync
  # Adds useful methods to {ChangeListIndex} and {ChangeDumpIndex}.
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
    # @return [Enumerator::Lazy<Resource>] those change lists whose +from_time+ *or* +until_time+
    #   falls within +in_range+
    def change_lists(in_range:, strict: true)
      resources.select { |r| resource_in_range(resource: r, range: in_range, strict: strict) }
    end

    private

    def resource_in_range(resource:, range:, strict:)
      return true unless strict || resource.from_time || resource.until_time
      from_in_range = resource.from_time ? range.cover?(resource.from_time) : false
      until_in_range = resource.until_time ? range.cover?(resource.until_time) : false
      from_in_range || until_in_range
    end
  end
end
