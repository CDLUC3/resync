require_relative 'shared/sorted_resource_list'
require_relative 'xml'

module Resync
  class ChangeDump < SortedResourceList
    include XML::Mapped

    CAPABILITY = 'changedump'
  end
end
