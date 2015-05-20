require_relative 'shared/base_resource_list'

module Resync
  # A change list. See section 8,
  # "{http://www.openarchives.org/rs/1.0/resourcesync#SourceDesc Describing the Source}",
  # in the ResourceSync specification.
  class SourceDescription < BaseResourceList
    include XML::Mapped

    # The capability provided by this type.
    CAPABILITY = 'description'

  end
end
