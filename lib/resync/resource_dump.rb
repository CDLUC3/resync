require_relative 'shared/base_resource_list'
require_relative 'xml'

module Resync
  class ResourceDump < BaseResourceList
    include ::XML::Mapping
    include XML::Convertible
    XML_TYPE = XML::Urlset
    CAPABILITY = 'resourcedump'

    use_mapping :_default
  end
end
