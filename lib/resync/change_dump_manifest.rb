require_relative 'shared/sorted_resource_list'
require_relative 'xml'

module Resync
  class ChangeDumpManifest < SortedResourceList
    include ::XML::Mapping
    include XML::Convertible

    CAPABILITY = 'changedump-manifest'
  end
end
