require_relative 'shared/sorted_resource_list'
require_relative 'xml'

module Resync
  # A change dump manifest. See section 13.2,
  # "{http://www.openarchives.org/rs/1.0/resourcesync#ChangeDumpManifest Change Dump Manifest}",
  # in the ResourceSync specification.
  class ChangeDumpManifest < SortedResourceList
    include XML::Mapped

    CAPABILITY = 'changedump-manifest'
  end
end
