require_relative 'shared/sorted_resource_list'

module Resync
  class ChangeDumpManifest < SortedResourceList
    CAPABILITY = 'changedump-manifest'
  end
end
