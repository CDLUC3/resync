require_relative 'shared/sorted_resource_list'
require_relative 'xml'

module Resync
  class ChangeList < SortedResourceList
    include XML::Convertible
    XML_TYPE = XML::Urlset
    CAPABILITY = 'changelist'
  end
end
