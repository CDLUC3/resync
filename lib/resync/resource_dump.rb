require_relative 'shared/base_resource_list'
require_relative 'xml'

module Resync
  class ResourceDump < BaseResourceList
    include ::XML::Mapping
    include XML::Convertible

    CAPABILITY = 'resourcedump'
  end
end
