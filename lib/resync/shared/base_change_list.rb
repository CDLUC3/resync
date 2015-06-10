require_relative 'sorted_resource_list'

# TODO: Make this a mixin
module Resync
  # Adds useful methods to {ChangeList} and {ChangeDumpManifest}.
  class BaseChangeList < SortedResourceList
    # Filters the list of changes by change type, modification time, or both.
    # @param of_type [Types::Change] the change type
    # @param in_range [Range<Time>] the range of modification times
    # @return [Enumerator::Lazy<Resource>] the matching changes, or all changes
    #   if neither +of_type+ nor +in_range+ is specified.
    def changes(of_type: nil, in_range: nil)
      resources.select do |r|
        is_of_type = of_type ? r.change == of_type : true
        is_in_range = in_range ? in_range.cover?(r.modified_time) : true
        is_of_type && is_in_range
      end
    end
  end
end
