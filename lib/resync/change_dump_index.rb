require_relative 'shared/sorted_resource_list'
require_relative 'shared/sitemap_index'

module Resync
  # A change dump index. See under section 13.1,
  # "{http://www.openarchives.org/rs/1.0/resourcesync#ChangeDumpIndex Change Dump}",
  # in the ResourceSync specification.
  class ChangeDumpIndex < SortedResourceList
    include ::XML::Mapping
    include SitemapIndex

    # The capability provided by this type.
    CAPABILITY = 'changedump'
  end
end
