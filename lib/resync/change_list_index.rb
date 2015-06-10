require_relative 'shared/sorted_resource_list'
require_relative 'shared/sitemap_index'

module Resync
  # A change list index. See section 12.2,
  # "{http://www.openarchives.org/rs/1.0/resourcesync#ChangeListIndex Change List Index}",
  # in the ResourceSync specification.
  class ChangeListIndex < SortedResourceList
    include ::XML::Mapping
    include SitemapIndex

    # The capability provided by this type.
    CAPABILITY = 'changelist'

    # Filters the list of change lists by from/until time
    # @param in_range [Range<Time>] the range of times to filter by
    # @return [Enumerator::Lazy<Resource>] those change lists whose +from_time+ *or* +until_time+
    #   falls within +in_range+
    def change_lists(in_range:) # TODO: Make this a mixin and include it in ChangeDumpIndex (?) as well
      resources.select do |r|
        from_in_range = r.from_time ? in_range.cover?(r.from_time) : false
        until_in_range = r.until_time ? in_range.cover?(r.until_time) : false
        from_in_range || until_in_range
      end
    end
  end
end
