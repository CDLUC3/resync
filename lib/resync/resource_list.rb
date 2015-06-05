require_relative 'shared/base_resource_list'
require_relative 'xml'

module Resync
  # A resource list. See section 10.1,
  # "{http://www.openarchives.org/rs/1.0/resourcesync#ResourceList Resource List}",
  # in the ResourceSync specification.
  class ResourceList < BaseResourceList
    include ::XML::Mapping

    # The capability provided by this type.
    CAPABILITY = 'resourcelist'
  end
end
