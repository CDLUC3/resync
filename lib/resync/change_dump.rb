require_relative 'shared/sorted_resource_list'

module Resync
  class ChangeDump < SortedResourceList
    CAPABILITY = 'changedump'
  end
end
