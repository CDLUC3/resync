require_relative 'shared/sorted_resource_list'
require_relative 'xml'

module Resync
  # A change list. See section 12.1,
  # "{http://www.openarchives.org/rs/1.0/resourcesync#ChangeList Change List}",
  # in the ResourceSync specification.
  class ChangeList < SortedResourceList
    include XML::Mapped

    CAPABILITY = 'changelist'
  end
end
