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
  end
end
