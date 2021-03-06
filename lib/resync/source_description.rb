require 'resync/shared/base_resource_list'

module Resync
  # A change list. See section 8,
  # "{http://www.openarchives.org/rs/1.0/resourcesync#SourceDesc Describing the Source}",
  # in the ResourceSync specification.
  class SourceDescription < BaseResourceList
    include ::XML::Mapping

    # The capability provided by this type.
    CAPABILITY = 'description'.freeze

  end
end
