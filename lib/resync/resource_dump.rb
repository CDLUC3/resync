require_relative 'shared/base_resource_list'
require_relative 'xml'

module Resync
  # A resource dump. See section 11.1,
  # "{http://www.openarchives.org/rs/1.0/resourcesync#ResourceDump Resource Dump}",
  # in the ResourceSync specification.
  class ResourceDump < BaseResourceList
    include XML::Mapped

    # The capability provided by this type.
    CAPABILITY = 'resourcedump'

  end
end
