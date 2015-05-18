require_relative 'shared/sorted_resource_list'
require_relative 'xml'

module Resync
  class ChangeDump < SortedResourceList
    include ::XML::Mapping
    include XML::Convertible
    XML_TYPE = XML::Urlset
    CAPABILITY = 'changedump'

    use_mapping :_default
  end
end
