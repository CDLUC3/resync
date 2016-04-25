require 'resync/shared/base_change_list'
require 'resync/xml'

module Resync
  # A change dump manifest. See section 13.2,
  # "{http://www.openarchives.org/rs/1.0/resourcesync#ChangeDumpManifest Change Dump Manifest}",
  # in the ResourceSync specification.
  class ChangeDumpManifest < BaseChangeList
    include ::XML::Mapping

    # The capability provided by this type.
    CAPABILITY = 'changedump-manifest'.freeze

  end
end
