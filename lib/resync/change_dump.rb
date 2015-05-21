require_relative 'shared/sorted_resource_list'
require_relative 'xml'

module Resync
  # A change dump. See section 13.1,
  # "{http://www.openarchives.org/rs/1.0/resourcesync#ChangeDump Change Dump}",
  # in the ResourceSync specification.
  class ChangeDump < SortedResourceList
    include ::XML::Mapping

    # The capability provided by this type.
    CAPABILITY = 'changedump'

  end
end
