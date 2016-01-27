require_relative 'shared/base_change_index'
require_relative 'shared/sitemap_index'

module Resync
  # A change dump index. See under section 13.1,
  # "{http://www.openarchives.org/rs/1.0/resourcesync#ChangeDumpIndex Change Dump}",
  # in the ResourceSync specification.
  class ChangeDumpIndex < BaseChangeIndex
    include ::XML::Mapping
    include SitemapIndex

    # The capability provided by this type.
    CAPABILITY = 'changedump'.freeze
  end
end
