require_relative 'sorted_list_base'

module Resync
  class ChangeList < SortedListBase
    CAPABILITY = 'changelist'
  end
end
