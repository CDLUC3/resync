require_relative 'shared/base_resource_list'
require_relative 'xml'

module Resync
  class ResourceDumpManifest < BaseResourceList
    include ::XML::Mapping
    include XML::Convertible

    CAPABILITY = 'resourcedump-manifest'
  end
end
