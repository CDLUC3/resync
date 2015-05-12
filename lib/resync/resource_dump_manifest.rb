require_relative 'shared/base_resource_list'

module Resync
  class ResourceDumpManifest < BaseResourceList
    CAPABILITY = 'resourcedump-manifest'
  end
end
