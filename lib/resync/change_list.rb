require_relative 'shared/sorted_resource_list'
require_relative 'xml'

module Resync
  class ChangeList < SortedResourceList
    include XML::Mapped

    CAPABILITY = 'changelist'
  end
end
