require_relative 'shared/base_resource_list'
require_relative 'xml'

module Resync
  class ResourceDump < BaseResourceList
    include XML::Mapped

    CAPABILITY = 'resourcedump'
  end
end
