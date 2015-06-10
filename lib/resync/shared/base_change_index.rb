require_relative 'sorted_resource_list'

module Resync
  # Adds useful methods to {ChangeListIndex} and {ChangeDumpIndex}.
  class BaseChangeIndex < SortedResourceList
    # Filters the list of change lists by from/until time
    # @param in_range [Range<Time>] the range of times to filter by
    # @return [Enumerator::Lazy<Resource>] those change lists whose +from_time+ *or* +until_time+
    #   falls within +in_range+
    def change_lists(in_range:)
      resources.select do |r|
        from_in_range = r.from_time ? in_range.cover?(r.from_time) : false
        until_in_range = r.until_time ? in_range.cover?(r.until_time) : false
        from_in_range || until_in_range
      end
    end
  end
end
