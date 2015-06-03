require_relative 'shared/base_resource_list'
require_relative 'shared/sitemap_index'

module Resync
  # A resource dump index. See under section 11.1,
  # "{http://www.openarchives.org/rs/1.0/resourcesync#ResourceDumpIndex Resource Dump}",
  # in the ResourceSync specification.
  class ResourceDumpIndex < BaseResourceList
    include ::XML::Mapping
    include SitemapIndex

    # The capability provided by this type.
    CAPABILITY = 'resourcedump'
  end
end
