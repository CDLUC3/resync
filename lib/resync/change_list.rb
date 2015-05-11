require_relative 'shared/sorted_resource_list'

module Resync
  class ChangeList < SortedResourceList
    CAPABILITY = 'changelist'
  end
end
