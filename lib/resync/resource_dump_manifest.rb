require 'resync/shared/base_resource_list'
require 'resync/xml'

module Resync
  # A resource dump. See section 11.2,
  # "{http://www.openarchives.org/rs/1.0/resourcesync#ResourceDumpManifest Resource Dump Manifest}",
  # in the ResourceSync specification.
  class ResourceDumpManifest < BaseResourceList
    include ::XML::Mapping

    # The capability provided by this type.
    CAPABILITY = 'resourcedump-manifest'.freeze

  end
end
