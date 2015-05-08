require_relative 'sorted_list_base'

module Resync
  class ChangeDump < SortedListBase
    CAPABILITY = 'changedump'
  end
end
