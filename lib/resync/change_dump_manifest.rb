require_relative 'shared/sorted_resource_list'
require_relative 'xml'

module Resync
  class ChangeDumpManifest < SortedResourceList
    include ::XML::Mapping
    include XML::Convertible
    XML_TYPE = XML::Urlset
    CAPABILITY = 'changedump-manifest'

    use_mapping :_default
  end
end
