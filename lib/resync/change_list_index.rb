require 'resync/shared/base_change_index'
require 'resync/shared/sitemap_index'

module Resync
  # A change list index. See section 12.2,
  # "{http://www.openarchives.org/rs/1.0/resourcesync#ChangeListIndex Change List Index}",
  # in the ResourceSync specification.
  class ChangeListIndex < BaseChangeIndex
    include ::XML::Mapping
    include SitemapIndex

    # The capability provided by this type.
    CAPABILITY = 'changelist'.freeze
  end
end
