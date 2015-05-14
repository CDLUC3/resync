require_relative 'shared/base_resource_list'
require_relative 'xml'

module Resync
  class ResourceDumpManifest < BaseResourceList
    include XML::Convertible
    XML_TYPE = XML::Urlset
    CAPABILITY = 'resourcedump-manifest'
  end
end
